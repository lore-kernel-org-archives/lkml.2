Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab2FRLym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:54:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33339 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2FRLyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:54:41 -0400
Message-ID: <4FDF16FB.6020300@monstr.eu>
Date: Mon, 18 Jun 2012 13:54:35 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 6/8] ARM: smp: Use generic API for ipi
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-7-git-send-email-monstr@monstr.eu> <20120618113617.GF12029@n2100.arm.linux.org.uk>
In-Reply-To: <20120618113617.GF12029@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:36 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 18, 2012 at 01:30:09PM +0200, Michal Simek wrote:
>> Support dynamic IPI allocation. It supports cases
>> where user wants to use IPI for communication among cpus
>> and setup own handler for it.
>>
>> New functions set_ipi_handler/clear_ipi_handler are used
>> for dynamic allocation.
>
> For what purpose?

Please look at my reaction in 4/8. It is the part of dynamic IPI allocation.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
