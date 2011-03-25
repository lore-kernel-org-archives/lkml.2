Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1CYO0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:26:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:51374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753606Ab1CYO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:26:44 -0400
Message-Id: <20110325142344.058372664@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:26:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 0/2] unicore32: Final irq bits for .39
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guan,

the following series converts unicore to the new irq function names
and makes use of the generic show_interrupts() implementation.

Can you please ack or send it to Linus yourself?

Thanks,

	tglx


