Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2BHM2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:28:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59079 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2BHM2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:28:02 -0500
Message-ID: <4F326A4E.1030106@monstr.eu>
Date: Wed, 08 Feb 2012 13:27:58 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.arm.linux.org.uk
Subject: CMA on arm from zero address
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to setup CMA space at the beginning of ram because
I want to use remoteproc to run code on the second cpu which has to use addresses 0x0 - 32MB.

I have changed textofs in arch/arm/Makefile but there is not possible to setup
all values which I would like to use. What is the reason for this limitation?

Marek: Have you tried to prototype this configuration with cma?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
