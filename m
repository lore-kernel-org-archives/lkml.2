Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1EHQpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 12:45:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42456 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1EHQpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 12:45:09 -0400
Message-ID: <4DC6C88A.5000601@ti.com>
Date: Sun, 8 May 2011 17:44:58 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCHv2 0/5] Add TPS65911 device
References: <6ECACA2B-DAAB-4321-9A5C-CA05521F1E81@slimlogic.co.uk>
In-Reply-To: <6ECACA2B-DAAB-4321-9A5C-CA05521F1E81@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/11 01:21, Jorge Eduardo Candelaria wrote:
> This is the initial version of the TPS65911 PMIC. This is a power management IC
> for multimedia products.
> 
> The driver is depends on the TPS65910 PMIC and provides the same functionality:
> Regulators, GPIO controller, RTC, etc. It also adds new functionality that was
> not present in TPS65910 chip.
> 
> Support for subsequent versions of this PMIC can be easily added after this set
> of patches.
> 
> Changes from v1:
> - Changed several if statements to switch-case for future-proofing.
> - Declared only on Comparator voltage table for COMP1 and COMP2.
> 
> GIT: [PATCHv2 1/5] MFD: TPS65910: Add support for TPS65911 device
> GIT: [PATCHv2 2/5] regulator: tps65911: Add new chip version
> GIT: [PATCHv2 3/5] TPS65911: Add new irq definitions
> GIT: [PATCHv2 4/5] TPS65911: Add support for added GPIO lines
> GIT: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver

Samuel, if you are happy enough with the MFD changes I can take through regulator again ?

Thanks

Liam
