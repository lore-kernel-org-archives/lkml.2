Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1GBBTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:19:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59514 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1GBBTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:19:50 -0400
Subject: [GIT PULL] x86 TSC change for 3.1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Tero Roponen <tero.roponen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 18:19:45 -0700
Message-ID: <1309569585.2872.403.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I've got one TSC patch queued in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/x86/tsc

Would you please consider queueing this into -tip for 3.1?

thanks
-john

Tero Roponen (1):
      x86: tsc: Remove unneeded DMI-based blacklisting

 arch/x86/kernel/tsc.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)


