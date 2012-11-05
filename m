Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2KENaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:30:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64315 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2KENaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:30:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121105131108.GC27238@kroah.com>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
	<20121105131108.GC27238@kroah.com>
Date: Mon, 5 Nov 2012 22:30:09 +0900
Message-ID: <CAOTypNS+js4e3-=ZbV3tzC-zGg3LQTc=3oiqiytTcF12Y4t4hg@mail.gmail.com>
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 10:11 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
>> fixed below checkpatch warnings.
>> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
>> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
>>  1 file changed, 18 insertions(+), 17 deletions(-)
>
> Please note that I don't touch the drivers/staging/media/* files, so
> copying me on these patches doesn't do anything :)

Thanks for your follow-up.

I tried to check in get_maintainer.pl...
Do I need to be re-sent to the address "Mauro Carvalho Chehab
<mchehab@infradead.org>"?


-- 

Regards,

YAMANE Toshiaki
