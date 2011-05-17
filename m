Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1EQIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:52:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab1EQIwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:52:18 -0400
Date: Tue, 17 May 2011 10:52:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH trivial] timers-howto: fix a typo ("unsgined")
In-Reply-To: <1305573335-28361-1-git-send-email-j.neuschaefer@gmx.net>
Message-ID: <alpine.LNX.2.00.1105171052080.28291@pobox.suse.cz>
References: <1305573335-28361-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Jonathan Neuschäfer wrote:

> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  Documentation/timers/timers-howto.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
> index c9ef29d..038f8c7 100644
> --- a/Documentation/timers/timers-howto.txt
> +++ b/Documentation/timers/timers-howto.txt
> @@ -24,7 +24,7 @@ ATOMIC CONTEXT:
>  
>  	ndelay(unsigned long nsecs)
>  	udelay(unsigned long usecs)
> -	mdelay(unsgined long msecs)
> +	mdelay(unsigned long msecs)
>  
>  	udelay is the generally preferred API; ndelay-level
>  	precision may not actually exist on many non-PC devices.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
