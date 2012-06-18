Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2FRLab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43210 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FRLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:28 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: ARM SMP/GIC/LDS patches for Xilinx Zynq remoteproc
Date: Mon, 18 Jun 2012 13:30:03 +0200
Message-Id: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am sending bunch of patches which I have made for a Xilinx Zynq remoteproc AMP solution +
some patches around.

Xilinx Zynq is dual core ARM Cortex A9. Remoteproc in new interface for controlling other cpus
is the system. I have created solution where on one ARM runs Linux and the second ARM
runs RTOS or any other standalone firmware. It is AMP between two ARM cores.

Communication is done via shared memory with kicking via IPI interrupts. 
Based on that I had to do some changes in the kernel which I am sending. 

Thanks for your review,
Michal

