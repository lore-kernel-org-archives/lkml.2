Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0HCSxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:53:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39419 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0HCSxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U5IR6k+0n8aqzhLQ7Wz59wD8418lblCjYw4wKPQ/xXclHuAljqfTkCBgQSFeyJW+0O
         4zDQNfb0urkMQ7M8MVJO/dpzvldibdiGNRKcU09LqZ8fyqgenf3lDeysU5wSO7zShItY
         3PeuEhVxtoHO1RRoLMD/9HAJ2IOG8bsVCFN64=
MIME-Version: 1.0
In-Reply-To: <20100803184915.GA23847@psychosis.jim.sh>
References: <AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
	<4C34B8BE.5080504@kernel.org>
	<AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
	<4C44BD42.3030904@kernel.org>
	<7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
	<4C45AF40.7030800@kernel.org>
	<AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
	<4C483BF4.3090006@kernel.org>
	<AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
	<20100803114105.7f199878.randy.dunlap@oracle.com>
	<20100803184915.GA23847@psychosis.jim.sh>
Date: Tue, 3 Aug 2010 11:53:42 -0700
Message-ID: <AANLkTi=1dFZ+APFx=W8YawtTDhOjVn1sVshUnSJ3OyCB@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Jim Paris <jim@jtan.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 11:49 AM, Jim Paris <jim@jtan.com> wrote:
> Randy Dunlap wrote:
>> On Mon, 2 Aug 2010 15:07:11 -0700 Mark Knecht wrote:
>>
>> > On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
>> >
>> > Hi Tejun,
>> >    I'm finally home and trying to get back to this. I'm really a bad
>> > programmer so I don't know what I've done wrong but it seems patch
>> > isn't happy with me.
>> >
>> > c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
>> > patching file drivers/ata/ata_piix.c
>> > patch: **** malformed patch at line 13:
>>
>> Whenever the patch file was saved on this system, line 13 of it was
>> split (probably by an email client).  Whenever I see this, I just
>> join (merge) that line and the next one and try again... sometimes
>> several lines are malformed and have to be fixed like this.
>
> Tejun asked Mark to add a printk, and Mark added it directly to the
> patch.  Mark, just apply the original patch as-is, and then add the
> printk to the source code in ata_piix.c.  You should add it somewhere
> like the piix_init_one function, e.g. right before the "Save IOCFG"
> comment around line 1575.
>
> -jim

Thanks Jim. I'll give it a shot.

Cheers,
Mark
