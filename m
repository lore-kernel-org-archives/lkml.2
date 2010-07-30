Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0G3J5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:57:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47287 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0G3J5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <20100730094038.GA9570@infradead.org>
References: <1280482741.1851.3.camel@yio.site> <20100730094038.GA9570@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 11:56:56 +0200
Message-ID: <AANLkTik-htE1mbJbnGCNwsjVJyWF24nA9dNbsRNMzuia@mail.gmail.com>
Subject: Re: [PATCH] block: move del_gendisk() from fs/partitions/check.c to 
	block/genhd.c
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 11:40, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 30, 2010 at 11:39:01AM +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: block: move del_gendisk() from fs/partitions/check.c to block/genhd.c
>>
>> Disk code belongs into genhd, not into the partition scanner code.
>
> Sounds fine for del_gendisk, but read_dev_sector which isn't mentioned
> here really is for partitioning.

Right, the next patch moves it to /block/partition.c, because all the
sysfs and driver core code really should not be below fs/.

If you want me to re reshuffle that, let me know. I was just annoyed
again, and after all these years I though it's time to move that stuff
around. :)

Thanks,
Kay
