Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab0JVSYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61863 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0JVSX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SxacLhXzQ9gmuvnR2DbOIfUZvUzVJZZMbShx5ePfsgr48pl6TBL8J5ffCevwvNh2eE
         bU5tjtFa53MJMH2ZEZbkOpfCi+s7Cl9AszssD4tkP3PZSifpuycEc3Bi+vEsEB0k0+7a
         xLEljtxCB5PbpJTqd21MW7HJ/+LXdxvyacik4=
Message-ID: <4CC1D6B6.7090702@gmail.com>
Date: Fri, 22 Oct 2010 20:23:50 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/8] removal of dead code from few files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This tree
git pull git://github.com/zimnylech/Linux-2.6-nps.git rodc3
contains 8 patches that removes dead code.

 arch/blackfin/include/asm/irqflags.h     |   32 -------------------------
 arch/blackfin/kernel/ipipe.c             |    7 -----
 arch/blackfin/kernel/traps.c             |   10 --------
 arch/h8300/kernel/time.c                 |    3 --
 arch/m68knommu/kernel/setup.c            |    3 --
 arch/m68knommu/platform/68VZ328/config.c |    5 ----
 arch/powerpc/include/asm/exception-64e.h |   38 ------------------------------
 arch/powerpc/kernel/process.c            |    5 ----
 arch/powerpc/mm/tlb_low_64e.S            |   10 --------
 drivers/serial/68328serial.h             |    5 ----
 10 files changed, 0 insertions(+), 118 deletions(-)

I have not tested this code yet - I'm waiting for comments like "yeah, this can be removed" or "don't touch this code moron, put down your crack pipe, and leave us alone" ;) (all comments about my gmail username will end up in spam folder)

Kind regards,
Zimny
