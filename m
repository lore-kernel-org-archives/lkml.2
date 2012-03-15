Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032241Ab2COUB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:01:28 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43830 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031929Ab2COUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:01:25 -0400
Message-ID: <4F624A8B.7040407@ti.com>
Date: Fri, 16 Mar 2012 01:31:15 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Add TI EMIF SDRAM controller driver
References: <1331835457-5390-1-git-send-email-aneesh@ti.com> <20120315190444.GE11142@kroah.com>
In-Reply-To: <20120315190444.GE11142@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012 12:34 AM, Greg KH wrote:
> On Thu, Mar 15, 2012 at 11:47:30PM +0530, Aneesh V wrote:
>> Add a driver for the EMIF SDRAM controller used in TI SoCs
>>
>> EMIF is an SDRAM controller that supports, based on its revision,
>> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
>> for LPDDR2.
>>
>> The driver supports the following features:
>> - Calculates the DDR AC timing parameters to be set in EMIF
>>    registers using data from the device data-sheets and based
>>    on the DDR frequency. If data from data-sheets is not available
>>    default timing values from the JEDEC spec are used. These
>>    will be safe, but not necessarily optimal
>> - API for changing timings during DVFS or at boot-up
>
> Is this a kernel/user API, or just an in-kernel API?

That's just an in-kernel API or more precisely callbacks to be
registered for DDR frequency change events.

thanks,
Aneesh
