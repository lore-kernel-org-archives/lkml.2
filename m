Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0JKRGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:06:16 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:47235 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755581Ab0JKRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:06:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=juULPT/Fs8PwOBaDwNp8CR+kYrwd0g1buvbugT/cfR9FylieMxZLwHDDqW2sH2PmTPptJzstT9WGtGYHfECBi+nKyQ6KM9GxRg11WsSmCbI8b87SbX1AtKEc7ZOvTpyX;
Date: Mon, 11 Oct 2010 10:09:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 29/47] pci: Convert msi to new irq_chip functions
Message-ID: <20101011100926.29241d87@jbarnes-desktop>
In-Reply-To: <20100930221741.327789575@linutronix.de>
References: <20100930221351.682772535@linutronix.de>
	<20100930221741.327789575@linutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 23:16:55 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/mach-iop13xx/msi.c            |    8 ++++----
>  arch/ia64/kernel/msi_ia64.c            |    4 ++--
>  arch/ia64/sn/kernel/msi_sn.c           |    4 ++--
>  arch/powerpc/platforms/cell/axon_msi.c |    6 +++---
>  arch/powerpc/platforms/pseries/xics.c  |    2 +-
>  arch/powerpc/sysdev/fsl_msi.c          |    4 ++--
>  arch/powerpc/sysdev/mpic_pasemi_msi.c  |   22 +++++++++++-----------
>  arch/powerpc/sysdev/mpic_u3msi.c       |   16 ++++++++--------
>  arch/sparc/kernel/pci_msi.c            |    8 ++++----
>  arch/x86/kernel/apic/io_apic.c         |    8 ++++----
>  drivers/pci/msi.c                      |   14 +++++++-------
>  include/linux/msi.h                    |    5 +++--
>  12 files changed, 51 insertions(+), 50 deletions(-)

I like the MSI bits here too.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
