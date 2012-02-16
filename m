Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2BPK2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:28:06 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:59648 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab2BPK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:28:04 -0500
Message-ID: <4F3CDA2D.2060001@ti.com>
Date: Thu, 16 Feb 2012 15:57:57 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/8] misc: ddr: add LPDDR2 data from JESD209-2
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-3-git-send-email-aneesh@ti.com> <4F3CD55C.2020002@ti.com>
In-Reply-To: <4F3CD55C.2020002@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 February 2012 03:37 PM, Santosh Shilimkar wrote:
> On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
>> add LPDDR2 data from the JEDEC spec JESD209-2. The data
>> includes:
>>
>> 1. Addressing information for LPDDR2 memories of different
>>     densities and types(S2/S4)
>> 2. AC timing data.
>>
>> This data will useful for memory controller device drivers
>>
>> Signed-off-by: Aneesh V<aneesh@ti.com>
> Sorry.. Missed one minor comment.
>
>> ---
>>   drivers/misc/Kconfig          |    8 ++
>>   drivers/misc/Makefile         |    1 +
>>   drivers/misc/jedec_ddr_data.c |  141 +++++++++++++++++++++++++++++++++
>>   include/linux/jedec_ddr.h     |  174 +++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 324 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/misc/jedec_ddr_data.c
>>   create mode 100644 include/linux/jedec_ddr.h
>>
>
> [...]
>
>> diff --git a/drivers/misc/jedec_ddr_data.c b/drivers/misc/jedec_ddr_data.c
>> new file mode 100644
>> index 0000000..299c056
>> --- /dev/null
>> +++ b/drivers/misc/jedec_ddr_data.c
>> @@ -0,0 +1,141 @@
>> +/*
>> + * DDR addressing details and AC timing parameters from JEDEC specs
>> + *
>> + * Copyright (C) 2010 Texas Instruments, Inc.
> Fix the year please. Should be 2012

Ok. Will do.
