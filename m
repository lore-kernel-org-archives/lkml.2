Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1CYOVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:21:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:48783 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753305Ab1CYOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:21:18 -0400
Message-Id: <20110325141938.846639464@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:21:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 0/2] tile: Final irq bits for .39
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

the series converts the irq functions to the new function names and
makes use of the generic show_interrupts() implementation.

Can you please ack or send it to Linus yourself ?

Thanks,

	tglx

