Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2E2Wva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:51:30 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54725 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751084Ab2E2Wv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:51:28 -0400
Message-ID: <4FC54EA7.3040102@xenotime.net>
Date: Tue, 29 May 2012 15:33:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Rodolfo Giometti <giometti@enneenne.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/pps: Fix a small spell mistake
References: <1338330455-6805-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1338330455-6805-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 03:27 PM, Devendra Naga wrote:

> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  Documentation/pps/pps.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
> index d35dcdd..c3228fd 100644
> --- a/Documentation/pps/pps.txt
> +++ b/Documentation/pps/pps.txt
> @@ -34,7 +34,7 @@ and record it for userland.
>  
>  Common use is the combination of the NTPD as userland program, with a
>  GPS receiver as PPS source, to obtain a wallclock-time with
> -sub-millisecond synchronisation to UTC.
> +sub-millisecond synchronization to UTC.


FWIW, typically we allow either UK or US English spellings.

>  
>  
>  RFC considerations



-- 
~Randy
