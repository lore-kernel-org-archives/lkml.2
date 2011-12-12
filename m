Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1LLKDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:03:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60732 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1LLKDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:03:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7b95ae00000198b-32-4ee5d15b9c3c
Message-id: <4EE5D155.8080105@samsung.com>
Date: Mon, 12 Dec 2011 19:03:01 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <1323422140-31332-1-git-send-email-dg77.kim@samsung.com>
 <1323422140-31332-2-git-send-email-dg77.kim@samsung.com>
 <20111209095855.GA1876@sirena.org.uk> <4EE5C330.8060902@samsung.com>
 <20111212094827.GA31568@opensource.wolfsonmicro.com>
In-reply-to: <20111212094827.GA31568@opensource.wolfsonmicro.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 12월 12일 18:48, Mark Brown wrote:
> On Mon, Dec 12, 2011 at 06:02:40PM +0900, Donggeun Kim wrote:
>> On 2011년 12월 09일 18:58, Mark Brown wrote:
>>> On Fri, Dec 09, 2011 at 06:15:39PM +0900, Donggeun Kim wrote:
> 
>>>> +	if (max77693_read_reg(i2c, MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
> 
>>> I'd suggest also verifying that the ID register has the expected value.
>>> If there's a chip reision register logging it can be helpful.
> 
>> The all expected values for the register are not specified at datasheet.
>> The perpose of the read function is simply checking the existence of the
>> device so that the following operations are stopped for error case.
> 
> With a name like "ID" it's clearly chip idenfication - you should at
> least be displaying the value if it might change as it's likely to be
> useful for diagnostics.
> 
It would be changed to display the value from the register in normal case.

Thanks.
-Donggeun
