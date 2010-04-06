Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0DFNjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:39:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:49335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0DFNjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:39:10 -0400
Message-Id: <20100406132807.698467930@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 06 Apr 2010 15:28:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, David Miller <davem@davemloft.net>, acme@redhat.com,
       paulus@samba.org, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-arch@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 0/3] IRQ disable vs NMI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set tries to solve the local_irq_disable() vs NMI problem
that SPARC has by providing new arch hooks and instrumenting the
existing interface to WARN on conflicting usage.

