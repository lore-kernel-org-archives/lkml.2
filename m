Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab1IJJNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 05:13:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:54549 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1IJJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 05:12:58 -0400
Date: Sat, 10 Sep 2011 11:12:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.4-rt13
Message-ID: <alpine.LFD.2.02.1109101052340.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0.4-rt13 release.

Changes versus 3.0.2-rt11

  * Migrate disable cure (Mike, Peter)

  * ARM smpboot fix
  
  * Printk debug (Peter)

  * Ftrace: workaround the waitqueue issue

Patch against 3.0.4 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.4-rt13.patch.gz

The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.4-rt13.tar.gz

For those who don't have 3.0.4 around:

  git://tesla.tglx.de/git/linux-2.6-tip rt/3.0
  
  https://tglx.de/~tglx/rt/patch-3.0.4.gz

Thanks,

	tglx
