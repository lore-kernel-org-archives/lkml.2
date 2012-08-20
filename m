Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2HTQGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:06:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35730 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2HTQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:06:53 -0400
Date: Mon, 20 Aug 2012 08:57:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: mingo@elte.hu, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/smphotplug] Fixes for Infiniband EHCA
Message-ID: <20120820155754.GA20682@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082016-9360-0000-0000-000009A4E198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas,

This pair of patches fixes a typo and some warnings in the tip/smp/hotplug
Infiniband patch.  They are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/smphotplug

  							Thanx, Paul

Paul E. McKenney (2):
      infiniband: ehca: Fix while->do-while conversion typo
      infiniband: ehca: Fix compiler warnings

 drivers/infiniband/hw/ehca/ehca_irq.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

