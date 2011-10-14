Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1JNSRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:17:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38174 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1JNSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:17:31 -0400
Date: Fri, 14 Oct 2011 14:17:15 -0400 (EDT)
Message-Id: <20111014.141715.847854706049881596.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] pata_pcmcia/ide-cs: move IDs table to
 <linux/pata_pcmcia_ids.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E986988.6080106@pobox.com>
References: <201110131312.14498.bzolnier@gmail.com>
	<4E986988.6080106@pobox.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 14 Oct 2011 11:17:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 14 Oct 2011 12:55:36 -0400

> On 10/13/2011 07:12 AM, Bartlomiej Zolnierkiewicz wrote:
>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Subject: [PATCH] pata_pcmcia/ide-cs: move IDs table
>> to<linux/pata_pcmcia_ids.h>
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> ---
>>   drivers/ata/pata_pcmcia.c | 74
>>   +---------------------------------------
>>   drivers/ide/ide-cs.c | 74 +---------------------------------------
>>   include/linux/pata_pcmcia_ids.h | 70
>>   +++++++++++++++++++++++++++++++++++++
>>   3 files changed, 75 insertions(+), 143 deletions(-)
> 
> I'm torn...  it is an obvious and simple consolidation, but I dislike
> dropping such a driver-specific turd in include/linux.  I also wonder
> if we want to continue adding new IDs to ide-cs?
> 
> David, any opinions?  I'm basically ok with any option: (a) take
> Bart's patch as-is (with your acked-by), (b) ignore the patch and set
> a no-new-ids policy for ide-cs, (c) other?

Option 'b' please, thanks.
