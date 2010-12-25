Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0LYPmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 10:42:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44622 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0LYPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 10:42:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 25 Dec 2010 16:42:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [PATCH] Prevent users from disabling tickless
Message-ID: <20101225164207.1dcd9e58@stein>
In-Reply-To: <20101221233942.GL1263@parisc-linux.org>
References: <20101221233942.GL1263@parisc-linux.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21 Matthew Wilcox wrote:
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -5,13 +5,9 @@ config TICK_ONESHOT
>  	bool
>  
>  config NO_HZ
> -	bool "Tickless System (Dynamic Ticks)"
> +	def_bool y
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
>  	select TICK_ONESHOT
> -	help
> -	  This option enables a tickless system: timer interrupts will
> -	  only trigger on an as-needed basis both when the system is
> -	  busy and when the system is idle.
>  
>  config HIGH_RES_TIMERS
>  	bool "High Resolution Timer Support"
> 

Even at a kconfig variable without prompt, a help section may be useful.
In case of this one, you should rather add to the text than remove it.
-- 
Stefan Richter
-=====-==-=- ==-- ==--=
http://arcgraph.de/sr/
