Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2JPSlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:41:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:45395 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2JPSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:41:46 -0400
Date: Tue, 16 Oct 2012 20:41:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.1-rt2
Message-ID: <alpine.LFD.2.02.1210162037380.2811@ionos>
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

I'm pleased to announce the 3.6.1-rt2 release.

Changes since 3.6.1-rt1:

	* Picked up Pauls git friendly quilt queue

	* Compile fix for !RT_FULL (Paul Gortemaker)

	* Crypto init order fix

	* Tiny RCU fix which affects UP and is a long standing bug
	  affecting 3.2 and 3.4-rt as well.

The delta patch against 3.6.1-rt1 is appended below and can be found here

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.1-rt1-rt2.patch.xz

The RT patch against 3.6.1 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.1-rt2.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.1-rt2.tar.xz

Enjoy,

	tglx
