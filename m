Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1BEUI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:08:58 -0500
Received: from www.tglx.de ([62.245.132.106]:44495 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BEUI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:08:56 -0500
Message-Id: <20110205200108.921707839@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 20:08:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 0/4] XEN: Interrupt cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

the following series converts the interrupt chips of XEN to the new
chip functions and the last patches replace the xen private resume
hackery.

The first two patches have no dependencies.

The last two need the modification to the generic interrupt layer. I
could either carry them through the genirq tree with your
acked-tested-whatever-by or I provide you a branch to pull that change
from. I need the genirq change local as it conflicts with other patches
in the pipeline. Either way works fine.

Thanks,

	tglx

