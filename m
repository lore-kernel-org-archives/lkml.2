Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1GVJMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:12:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:46110 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1GVJMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:12:52 -0400
Message-Id: <20110722091011.717194327@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jul 2011 09:12:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>
Subject: [patch 0/3] rtc: Assorted bug fixes
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a few interesting bugs in the RTC code.

Thanks,

	tglx



