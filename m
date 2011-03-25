Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1CYNun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:50:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:50876 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752549Ab1CYNuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:50:40 -0400
Message-Id: <20110325134935.999574075@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:50:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 0/2] microblaze: Final irq bits for .39
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

the following patches convert to the new irq function names and make
use of the generic show_interrupts().

Thanks,

	tglx

