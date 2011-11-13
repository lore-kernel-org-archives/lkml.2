Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1KMNE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:04:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1KMNE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:04:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6528"; a="137237372"
Message-ID: <29dbe1d4d0e92bc4b4acf1ac2909f2df.squirrel@www.codeaurora.org>
In-Reply-To: <ea21d88d904af165cb911354e3f51ea6.squirrel@www.codeaurora.org>
References: <620ec9ffa6bdbba9ae5f76998e36f8dc.squirrel@www.codeaurora.org>
    <001001cca043$395dbfc0$ac193f40$%jun@samsung.com>
    <CANfBPZ-Zn+R4GosEL-RJxh8gduAr8e+qN876uPwDkHfiEpdERw@mail.gmail.com>
    <ea21d88d904af165cb911354e3f51ea6.squirrel@www.codeaurora.org>
Date: Sun, 13 Nov 2011 05:04:26 -0800 (PST)
Subject: Re: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5      
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: "S, Venkatraman" <svenkatr@ti.com>, merez@codeaurora.org,
        linux-mmc@vger.kernel.org, "Chris Ball" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, Nov 11, 2011 at 12:56 PM, Seungwon Jeon <tgih.jun@samsung.com>
>> wrote:
>>> Maya Erez wrote:
>>>> On Thu, Nov 10, 2011 Maya Erez wrote:
>>>> > S, Venkatraman <svenkatr@ti.com> wrote:
>>>> >> On Thu, Nov 3, 2011 at 7:23 AM, Seungwon Jeon
>>>> <tgih.jun@samsung.com>
>>>> wrote:
>>>> >> >> > +static u8 mmc_blk_chk_packable(struct mmc_queue *mq, struct
>>>> >> request *req)
>>>>
>>>> The function prepares the checkable list and not only checks if
>>>> packing
>>>> is
>>>> possible, therefore I think its name should change to reflect its real
>>>> action
>>> I labored at naming. Isn't it proper? :)
>>> Do you have any recommendation?
>>> group_pack_req?
>>>
How about mmc_blk_prep_packed_list?

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


