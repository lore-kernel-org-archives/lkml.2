Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1FDBIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 21:08:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55026 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1FDBIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 21:08:31 -0400
Subject: [GIT pull] PTP fixes for 3.0
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Dan Carpenter <error27@gmail.com>,
        Richard Cochran <richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 18:08:27 -0700
Message-ID: <1307149707.11492.66.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, 
	Here are some PTP fixes needed for 3.0. Please take a look at them and
queue them for Linus.

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.0/tip/timers/ptp

Dan Carpenter (2):
      ptp: Return -EFAULT on copy_to_user() errors
      ptp: Fix some locking bugs in ptp_read()

 drivers/ptp/ptp_chardev.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)


