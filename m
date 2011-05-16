Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1EPMeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:34:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48026 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1EPMeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:34:15 -0400
Message-ID: <4DD119BF.9030608@ti.com>
Date: Mon, 16 May 2011 13:34:07 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCHv2 1/5] MFD: TPS65910: Add support for TPS65911 device
References: <A6D68D26-06DE-4FF5-ABF3-372D742F606F@slimlogic.co.uk> <20110513163013.GI8970@sortiz-mobl>
In-Reply-To: <20110513163013.GI8970@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/11 17:30, Samuel Ortiz wrote:
> Hi Jorge,
> 
> On Wed, May 04, 2011 at 07:21:21PM -0500, Jorge Eduardo Candelaria wrote:
>> The TPS65911 is the next generation of the TPS65910 family of
>> PMIC chips. It adds a few features:
>>
>> - Watchdog Timer
>> - PWM & LED generators
>> - Comparators for system control status
>>
>> It also adds a set of Interrupts and GPIOs, among other things.
>>
>> The driver exports a function to identify between different
>> versions of the tps65910 family, allowing other modules to
>> identify the capabilities of the current chip.
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Liam, I'm ok with this one going through your tree.
> 

Jorge, could you fix up 4/5 re the review comment and resend with Ack's. I'll then apply.

Thanks

Liam

