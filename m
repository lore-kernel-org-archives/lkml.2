Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2KKMOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:14:46 -0500
Received: from mail.pbcl.net ([88.198.119.4]:53473 "EHLO hetzner.pbcl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KKMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:14:44 -0500
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2012 07:14:44 EST
Message-ID: <1352634461.6869.106.camel@x121e.pbcl.net>
Subject: Re: [PATCH 03/11] m68k: set arch_gettimeoffset directly
From: Phil Blundell <philb@gnu.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joshua Thompson <funaho@jurai.org>, Sam Creasey <sammy@sammy.net>
Date: Sun, 11 Nov 2012 11:47:41 +0000
In-Reply-To: <1352408516-21988-5-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
	 <1352408516-21988-5-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 14:01 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> remove m68k's mach_gettimeoffset function pointer, and instead directly
> set the arch_gettimeoffset function pointer. This requires multiplying
> all function results by 1000, since the removed m68k_gettimeoffset() did
> this. Also, s/unsigned long/u32/ just to make the function prototypes
> exactly match that of arch_gettimeoffset.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Philip Blundell <philb@gnu.org>

Acked-by: Phil Blundell <philb@gnu.org>

> Cc: Joshua Thompson <funaho@jurai.org>
> Cc: Sam Creasey <sammy@sammy.net>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>


