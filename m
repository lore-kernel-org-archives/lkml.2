Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab2FRLzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:55:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33339 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2FRLy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:54:59 -0400
Message-ID: <4FDF170D.3020107@monstr.eu>
Date: Mon, 18 Jun 2012 13:54:53 +0200
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
Subject: Re: [RFC PATCH 5/8] AMP: smp: Extend number of IPIs
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-6-git-send-email-monstr@monstr.eu> <20120618113548.GE12029@n2100.arm.linux.org.uk>
In-Reply-To: <20120618113548.GE12029@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:35 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 18, 2012 at 01:30:08PM +0200, Michal Simek wrote:
>> GIC supports up to 16 IPIs.
>>
>> Signed-off-by: Michal Simek<monstr@monstr.eu>
>>
>> ---
>> Please correct me if this code is also designed for different
>> interrupt controller which doesn't support 16 IPIs.
>
> This code is not specific to the GIC.  We use NR_IPI to indicate the
> number of IPIs that the kernel actually uses, not the number which the
> hardware provides.

ok.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
