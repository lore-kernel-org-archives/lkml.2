Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab2CMJly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:41:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54463 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab2CMJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:41:51 -0400
Message-ID: <4F5F1657.9090200@monstr.eu>
Date: Tue, 13 Mar 2012 10:41:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: remoteproc: Resource table for IRQs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad and others,

I would like to open new topic about remoteproc and IRQ.
As you know we run AMP on dual core arm cortex A9. The first
cpu runs Linux and the second rtos.

Both cpus use the same GIC and Linux is able to forward IRQ
to specific CPU. Currently this functionality is hardcoded
and the kernel always forward specific IRQs to firmware.

I think that will be good to move IRQ description to resource table
and kernel could check if this IRQ is used or not and if not then
setup GIC to forward this IRQ to the second CPU.

I think that reasonable solution is to extend fw_resource_type for RSC_IRQ.

What do you think?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
