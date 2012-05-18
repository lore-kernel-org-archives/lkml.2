Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966167Ab2ERRup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:50:45 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:28828 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965967Ab2ERRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:50:43 -0400
Date: Fri, 18 May 2012 19:50:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 20/24] sparc: Use: generic time config
Message-ID: <20120518175041.GA17334@merkur.ravnborg.org>
References: <20120518163020.548627576@glx-um.de> <20120518163106.987564297@glx-um.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518163106.987564297@glx-um.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anna-Maria.

I really like the cleanup provided by this patch-set, but..

On Fri, May 18, 2012 at 04:45:54PM -0000, Anna-Maria Gleixner wrote:
> Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  arch/sparc/Kconfig |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> Index: linux/arch/sparc/Kconfig
> ===================================================================
> --- linux.orig/arch/sparc/Kconfig
> +++ linux/arch/sparc/Kconfig
> @@ -30,11 +30,13 @@ config SPARC
>  	select USE_GENERIC_SMP_HELPERS if SMP
>  	select GENERIC_PCI_IOMAP
>  	select HAVE_NMI_WATCHDOG if SPARC64
> +	select GENERIC_CMOS_UPDATE

I do not see where we define the GENERIC_CMOS_UPDATE symbol,
so this looks wrong.

I looked only in upstream - and I did not look
in -tip.

	Sam
