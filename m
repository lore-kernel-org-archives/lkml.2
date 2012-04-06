Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2DFRiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:38:15 -0400
Received: from masquerade.micron.com ([137.201.242.130]:44411 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2DFRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:38:14 -0400
Message-ID: <4F7F2A01.6050806@micron.com>
Date: Fri, 6 Apr 2012 10:38:09 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 0/5] mtip32xx: Add support for device status and some
 optimitizations
References: <4F7E07BB.4080507@micron.com> <4F7E371B.8010605@kernel.dk>
In-Reply-To: <4F7E371B.8010605@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--7.593300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2012 5:21 PM, Jens Axboe wrote:

> On 2012-04-05 14:59, Asai Thambi S P wrote:
>>
>> This patchset adds support for new sysfs entry 'status', fix in restart port,
>> and some optimizations like merging various flag variables. 
>>
>> Asai Thambi S P (5):
>>   mtip32xx: Add new bitwise flag 'dd_flag' and make set comp_time as
>>     common
>>   mtip32xx: Add new sysfs entry 'status' and fix restart port
>>   mtip32xx: Shorten macro names
>>   mtip32xx: handling of commands in various scenarios
>>   mtip32xx: dump tagmap on failure
>>
>>  drivers/block/mtip32xx/mtip32xx.c |  844 +++++++++++++++++++++++++++++--------
>>  drivers/block/mtip32xx/mtip32xx.h |   58 ++-
>>  2 files changed, 702 insertions(+), 200 deletions(-)
> 
> These are not applying to for-3.4/drivers, so I can't apply them as-is.
> 


Sorry, patches were based on master. I will re-base for-3.4/drivers

--
Regards,
Asai Thambi
