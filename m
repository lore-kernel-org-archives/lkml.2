Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1LVIGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:06:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44690 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1LVIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:06:36 -0500
Message-ID: <4EF2E50A.7040506@monstr.eu>
Date: Thu, 22 Dec 2011 09:06:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/4] microblaze: Remove NO_IRQ from architecture
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu> <1324477932-19262-2-git-send-email-monstr@monstr.eu> <1324477932-19262-3-git-send-email-monstr@monstr.eu> <1324477932-19262-4-git-send-email-monstr@monstr.eu> <4EF258FE.9030709@gmail.com>
In-Reply-To: <4EF258FE.9030709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon wrote:
> On 22/12/11 01:32, Michal Simek wrote:
> 
>> NO_IRQ shouldn't be used by any driver. All Microblaze
>> drivers are fixed that's why NO_IRQ can be removed.
> 
> 
> This only describes half of what the patch does. You should also state
> that arch/microblaze/pci/pci-common.c has references to NO_IRQ removed.
> Maybe it' worth splitting this patch in half so the final patch just
> does the removal of the NO_IRQ definition, but maybe that is overkill?

I have decided to remove NO_IRQ from arch/microblaze in one patch.
It is less painful because if there is any problem with PCI you can revert
just one patch instead of two.

Drivers out of arch/microblaze must be in separate patches.


> Other than that, for the whole series:
> 
> Reviewed-by: Ryan Mallon <rmallon@gmail.com>

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
