Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0JEAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:25:26 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:41227
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189Ab0JEAZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:25:24 -0400
Date: Mon, 4 Oct 2010 17:23:24 -0700
From: matt mooney <mfm@muteddisk.com>
To: Sami Kerola <kerolasa@iki.fi>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] Documentation/networking/ip-sysctl.txt tcp_tw_recycle
 & tcp_tw_reuse
Message-ID: <20101005002324.GB6369@haskell.muteddisk.com>
Mail-Followup-To: Sami Kerola <kerolasa@iki.fi>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
References: <1286213524-4659-1-git-send-email-kerolasa@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286213524-4659-1-git-send-email-kerolasa@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:32 Mon 04 Oct     , Sami Kerola wrote:
> From: Sami Kerola <kerolasa@iki.fi>
> 
> Instead of saying 'consult your technical export' the
> documentation needs to assist an export to decide whether to keep
> these settings off or set them on.
> 
> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
> ---
>  Documentation/networking/ip-sysctl.txt |   20 +++++++++++++-------
>  1 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index f350c69..01e2948 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -444,15 +444,21 @@ tcp_tso_win_divisor - INTEGER
>  	Default: 3
>  
>  tcp_tw_recycle - BOOLEAN
> -	Enable fast recycling TIME-WAIT sockets. Default value is 0.
> -	It should not be changed without advice/request of technical
> -	experts.
> +	Enable fast recycling TIME-WAIT sockets. See also caution
> +	wrote to tcp_tw_reuse. Default value is 0.
>  
>  tcp_tw_reuse - BOOLEAN
> -	Allow to reuse TIME-WAIT sockets for new connections when it is
> -	safe from protocol viewpoint. Default value is 0.
> -	It should not be changed without advice/request of technical
> -	experts.
> +	Allow to reuse TIME-WAIT sockets for new connections when it is safe
> +	from protocol viewpoint. One should enable also tcp_timestamps when
> +	this is enabled. Default value is 0.
> +
> +	Caution. Both tcp_tw_recycle and tcp_tw_reuse can cause problems. You
> +	should not enable either without being sure about network topology in
> +	between node(s) which are using, or used by, the node(s) where the
> +	parameter is enabled. Connections that go via TCP state aware nodes,
> +	such as firewalls, NAT devices or load balancers may start drop frames
> +	because of the setting. The more there are connections the greater is
> +	the likelyhood you will see this issue.
>  
>  tcp_window_scaling - BOOLEAN
>  	Enable window scaling as defined in RFC1323.

This is poorly written and contains numerous grammatical errors. To name a few:

The use of "also" is all wrong; I think you're trying to use it as a conjunction
but instead it is being used as an adverb, which is modifying a noun (there are
very few instances where adverbs come before nouns). "wrote" is the wrong form
of the verb; moreover, the sentence itself is an imperative, so the main verb is
"see," and there should not be another conjugated verb in the sentence. Next,
"which" is wrong here; the clause that follows "which" is restrictive and
therefore "that" should be used instead. The last issue I will mention is
"likelyhood" is not a word, but I am sure you meant "likelihood."

-mfm

