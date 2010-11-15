Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab0KOEdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:33:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab0KOEdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ppCDmit18jINrbk5cBCqcrFcBUNSzTHRx3g+mD1GXGD3BUiRnzugbShoQFRQpbmZPQ
         n+YLTnwRoimd61goJf7cl5faMvQeiIJDA60AdqcvO+k40eQ3ujxL+PN0qL1kmzY26P3g
         An7FDquSJ+U0mM5uxgdlywa+mww/+CCuwP5ac=
MIME-Version: 1.0
In-Reply-To: <20101113233353.GB18658@thunk.org>
References: <201011032334.30662.thomas@m3y3r.de>
	<201011080014.33354.thomas@m3y3r.de>
	<alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
	<1289242528.11571.8.camel@localhost.localdomain>
	<alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
	<1289418184.6530.6.camel@localhost.localdomain>
	<20101113233353.GB18658@thunk.org>
Date: Mon, 15 Nov 2010 10:03:14 +0530
Message-ID: <AANLkTimM3o19L7WNRYRrBPuwMMK9187_U8nUmZ2e4=qd@mail.gmail.com>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
From: Ganesh Reddy K <ganeshreddyk@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to disable 'Large  physical address support' in 2.6.34 Linux
kernel LTIB.     i.e 64 Bit memory addressing and Page tables.

Along with this ,am i need to any other changes to have the kernel
without 64 Bit address completely and page table entries.



===========================================
arch/powerpc/platforms/Kconfig.cputype

config PHYS_64BIT
        bool 'Large physical address support' if E500 || PPC_86xx
        depends on (44x || E500 || PPC_86xx) && !PPC_83xx && !PPC_82xx
        ---help---
          This option enables kernel support for larger than 32-bit physical
          addresses.  This feature may not be available on all cores.

          If you have more than 3.5GB of RAM or so, you also need to enable
          SWIOTLB under Kernel Options for this to work.  The actual number
          is platform-dependent.

          If in doubt, say N here.
===========================================

Thanks in advance,
Ganesh
