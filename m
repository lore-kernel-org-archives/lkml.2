Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2GQJPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:15:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2GQJPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:15:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Tue, 17 Jul 2012 08:02:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120716121651.GA18859@elf.ucw.cz> <50050ECE.8020100@jonmasters.org>
In-Reply-To: <50050ECE.8020100@jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207170802.56434.arnd@arndb.de>
X-Provags-ID: V02:K0:3Dt9TUd5f3MnlUtnz5LY+9aKWiJEyWHKifeGOefCDNh
 pkmuqgTDCYDFag4WL5jKuuFI35lDvv+WWcgOzxPorPeqa8xedf
 s/LLu5OzOdkeG/hlFAp6Wc99jVa3W3/pMwyoG3ZNhKBhvCGwIy
 sV+S98wJ2a+UqXTZ9tfXTKE9wXD4+Ja7lEXEfzoqagfLfo//w5
 gTGv6gyHEImAU3XP2nSTB0Am4dhD46LFeAe6Mtmmhv60YNbQ+Z
 l7rVjXEdlgnvdlkzDPsrkpVfto1SkhAmGJCbUfhIpVu7phtzsO
 iBnuzLrYvJA9jFwqASVdZEINfcVTlVj0ZonKG0iEUC4P58Zz0N
 NwFxcMYVWSEC8tBv1VfA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, Jon Masters wrote:
> On 07/16/2012 08:16 AM, Pavel Machek wrote:
> 
> >> If an implementation supports AArch32 at EL3 there could be some
> >> physical (or some FPGA config) switch to choose between the two. But
> >> since AArch64 is mandated, I don't see why one would force AArch32 at
> >> EL3 and therefore all lower exception levels (and make a big part of the
> >> processor unused).
> > 
> > Actually I see one ... and I can bet it will happen.
> > 
> > So you create that shiny new ARMv8 compliant CPU, 8 cores, 2GHz. HTC
> > will want to use it with 1GB of RAM... and put around exiting OMAP
> > perihepals.
> 
> But that's why we have Eagle (A15). It's a very capable 32-bit design
> from ARM and far more sensible for such designs. You can easily build
> something with a few A15 clusters in it, as we're already seeing.

Right, I would say that with any CPU core more powerful than this one
or with more than a few of these, you will also have trouble coming
up with workloads that really require the CPU performance but don't
also require a 64 bit virtual address space in either user space
or kernel.

	Arnd

