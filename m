Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2EaP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:59:48 -0400
Received: from masquerade.micron.com ([137.201.242.130]:48941 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab2EaP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:59:47 -0400
Message-ID: <4FC7956F.7030505@micron.com>
Date: Thu, 31 May 2012 08:59:43 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 00/11] mtip32xx: Number of small tweaks and a new sysfs
 entry
References: <4FC57A61.5050607@micron.com> <4FC71388.40601@kernel.dk>
In-Reply-To: <4FC71388.40601@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18938.007
X-TM-AS-Result: No--12.069800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2012 11:45 PM, Jens Axboe wrote:

> On 05/30/2012 03:39 AM, Asai Thambi S P wrote:
>> This patchset includes number of small tweaks and adds a new sysfs entry 'flags'
>>
>> Asai Thambi S P (11):
>>   mtip32xx: fix clearing an incorrect register in mtip_init_port
>>   mtip32xx: Set custom timeouts for PIO commands
>>   mtip32xx: Change HDIO_GET_IDENTITY to return stored data
>>   mtip32xx: Fix to handle TFE for PIO(IOCTL/internal) commands
>>   mtip32xx: Set block queue boundary variables
>>   mtip32xx: Use plain spinlock for 'cmd_issue_lock'
>>   mtip32xx: Fix to support more than one sector in exec_drive_command()
>>   mtip32xx: minor performance tweak
>>   mtip32xx: Convert macro definitions for flag bits to enum
>>   mtip32xx: Changes to sysfs entries
>>   mtip32xx: Change disk capacity unit from MB to MiB
> 
> Looks fine, only real issue was with 5/5. I've fixed up that patch and
> applied all 11, thanks.
> 


Thanks.
