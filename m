Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1EITba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:31:30 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60960 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab1EITb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:31:29 -0400
Subject: Re: [PATCHv2 0/5] Add TPS65911 device
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
In-Reply-To: <4DC6C88A.5000601@ti.com>
Date: Mon, 9 May 2011 14:31:24 -0500
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Content-Transfer-Encoding: 8BIT
Message-Id: <3E30D2F0-145C-44BD-A52D-FC668EC19C4D@slimlogic.co.uk>
References: <6ECACA2B-DAAB-4321-9A5C-CA05521F1E81@slimlogic.co.uk> <4DC6C88A.5000601@ti.com>
To: Liam Girdwood <lrg@ti.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8, 2011, at 11:44 AM, Liam Girdwood wrote:

> On 05/05/11 01:21, Jorge Eduardo Candelaria wrote:
>> This is the initial version of the TPS65911 PMIC. This is a power management IC
>> for multimedia products.
>> 
>> The driver is depends on the TPS65910 PMIC and provides the same functionality:
>> Regulators, GPIO controller, RTC, etc. It also adds new functionality that was
>> not present in TPS65910 chip.
>> 
>> Support for subsequent versions of this PMIC can be easily added after this set
>> of patches.
>> 
>> Changes from v1:
>> - Changed several if statements to switch-case for future-proofing.
>> - Declared only on Comparator voltage table for COMP1 and COMP2.
>> 
>> GIT: [PATCHv2 1/5] MFD: TPS65910: Add support for TPS65911 device
>> GIT: [PATCHv2 2/5] regulator: tps65911: Add new chip version
>> GIT: [PATCHv2 3/5] TPS65911: Add new irq definitions
>> GIT: [PATCHv2 4/5] TPS65911: Add support for added GPIO lines
>> GIT: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver
> 
> Samuel, if you are happy enough with the MFD changes I can take through regulator again ?

Samuel, any update on the MFD changes above?

Thanks,
Jorge
> 
> Thanks
> 
> Liam

