Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0IWH71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:59:27 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43749 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab0IWH70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:59:26 -0400
Message-ID: <4C9B08CF.6000504@fusionio.com>
Date: Thu, 23 Sep 2010 09:59:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] floppy: switch to one queue per drive instead of  sharing
 a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel  OOPs
 when usb key  is inserted")
References: <20100920130318.GA29565@lst.de> <4C975DCC.9050902@fusionio.com> <20100920223001.GJ6138@redhat.com> <20100921182529.GA31132@redhat.com> <4C992F12.5090000@fusionio.com> <20100922204216.GA7487@redhat.com>
In-Reply-To: <20100922204216.GA7487@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-22 22:42, Vivek Goyal wrote:
> On Wed, Sep 22, 2010 at 12:17:54AM +0200, Jens Axboe wrote:
> 
> [..]
>> Super, thanks a lot! I will queue this up. If you want to continue
>> this (very noble) crusade, the next target is
>> drivers/mtd/mtd_blkdevs.c. I never got that one started, but it was
>> next on my list.
> 
> Hi Jens,
> 
> IIUC, for MTD this conversion is already done and we seem to be using separate
> request queue for each gendisk instead of some disks sharing a single
> request queue. I think by following is relevant commit. Maxim should be
> able to confirm though.

Great! So the question is if other drivers with shared queues remain.

-- 
Jens Axboe

