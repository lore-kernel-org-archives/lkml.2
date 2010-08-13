Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517Ab0HMLrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 07:47:00 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:47515 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0HMLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:46:57 -0400
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2010 07:46:57 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201008131135.o7DBZYRr018759@clem.clem-digital.net>
Subject: 2.6.35-git12 fails compile (update_wall_time)
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Fri, 13 Aug 2010 07:35:34 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi: i386 UP

  LD      net/netfilter/built-in.o
  LD      net/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `update_wall_time':
(.text+0x2227b): undefined reference to `__umoddi3'
kernel/built-in.o: In function `update_wall_time':
(.text+0x2229a): undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

-- 
Pete Clements 
