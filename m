Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1EUH7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 03:59:18 -0400
Received: from daytona.panasas.com ([67.152.220.89]:18124 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1EUH7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 03:59:16 -0400
Message-ID: <4DD770CE.7040001@panasas.com>
Date: Sat, 21 May 2011 10:59:10 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110430 Remi/fc12 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jim Cromie <jim.cromie@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com> <1305840792-25877-9-git-send-email-jim.cromie@gmail.com> <4DD68BE0.6030003@panasas.com> <BANLkTi=6qWpUX6wMi5egRhi+qigaGPgnFQ@mail.gmail.com>
In-Reply-To: <BANLkTi=6qWpUX6wMi5egRhi+qigaGPgnFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2011 07:59:15.0728 (UTC) FILETIME=[FAC9A100:01CC178C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 07:21 AM, Jim Cromie wrote:
> On Fri, May 20, 2011 at 9:42 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On 05/20/2011 12:33 AM, Jim Cromie wrote:
>>> cc: Doug Gilbert <dgilbert@interlog.com>
>>> cc: linux-scsi@vger.kernel.org
>>> cc: Benny Halevy <bhalevy@panasas.com>
>>> cc: Boaz Harrosh <bharrosh@panasas.com>
>>> cc: osd-dev@open-osd.org
>>> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>>> cc: linux-scsi@vger.kernel.org
>>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>>> ---
>>>  drivers/scsi/osd/osd_uld.c |    6 +++---
>>>  drivers/scsi/pmcraid.c     |    3 +--
>>>  drivers/scsi/sg.c          |    6 +++---
>>>  drivers/scsi/st.c          |    7 +++----
>>>  4 files changed, 10 insertions(+), 12 deletions(-)
>>
>> Do you have a git tree with all these that I can pull
>> and test?
>>
> 
> I do, its at git://github.com/jimc/linux-2.6.git  chrdev-pub1 branch
> 
> For you, I think there are 3 patches of interest
> 1 - adds new call, deprecates old.
> if you build with this applied and CONFIG_ENABLE_WARN_DEPRECATED=y
> you should get a deprecated warning
> 2 - reimplements alloc_chardev_region() with register_chardev_ids()
> your driver may be using register_chardev_region(), if so this is uninteresting.
> 3 - patch that adapts your scsi parts.
> 
>> Thanks
>> Boaz
>>
> 
> no, thank you
> Jim Cromie

Grate many thanks. I will test it next week and confirm.

Boaz
