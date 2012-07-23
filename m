Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2GWEwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 00:52:39 -0400
Received: from oproxy10-pub.bluehost.com ([67.222.39.61]:38560 "HELO
	oproxy10-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752976Ab2GWEwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 00:52:38 -0400
Message-ID: <500CD6CC.2000108@xenotime.net>
Date: Sun, 22 Jul 2012 21:45:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Beller <stefanbeller@googlemail.com>
CC: rob@landley.net, jgarzik@pobox.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Rewrite Documentation/SubmittingPatches.
References: <500BAFE0.8070108@googlemail.com> <500BB232.7000108@googlemail.com>
In-Reply-To: <500BB232.7000108@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 12:56 AM, Stefan Beller wrote:

>  Documentation/SubmittingPatches | 191 ++++++++++++++++++++++++----------------
>  1 file changed, 116 insertions(+), 75 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index c379a2a..ac00451 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -163,9 +157,9 @@ Do not send more than 15 patches at once to the vger mailing lists!!!
>  Linus Torvalds is the final arbiter of all changes accepted into the
> -Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
> +Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.


what are the changes on the line above and below, please?

>  He gets a lot of e-mail, so typically you should do your best to -avoid-
> -sending him e-mail.
> +sending him e-mail.




thanks,

-- 

~Randy
