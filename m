Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1CYOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:16:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:36992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810Ab1CYOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:16:56 -0400
Message-Id: <20110325141528.825456671@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:16:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 0/4] score: Final irq bits for .39
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen,

the following series contains:

    - irq_chip conversion (Resend)
    - Conversion to new irq function names
    - Use generic show_interrupts()

Can you please ack or send them to Linus yourself?

Thanks,

	tglx

