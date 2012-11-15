Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2KOV5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:57:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35704 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KOV5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:57:48 -0500
MIME-Version: 1.0
In-Reply-To: <50A55CFE.3030107@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <1352995520.26800.2.camel@rig.fritz.box> <50A55CFE.3030107@cs.tu-berlin.de>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 15 Nov 2012 22:57:26 +0100
Message-ID: <CAPXgP12k25=BZ7=9xdxWDratzh7T+1=jOKBOAmqEZbgiTxZGYA@mail.gmail.com>
Subject: Re: [PATCH 00/12] printk() fixes, optimizations, and clean ups
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 10:22 PM, "Jan H. Schönherr"
<schnhrr@cs.tu-berlin.de> wrote:
> Am 15.11.2012 17:05, schrieb Kay Sievers:
>> This with all your patches applied:
>> [    1.032804] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
>> [    1.063915] List of all partitions:
>> [    1.065521] 0800       117220824 sda  driver: sd
>> [    1.067444]   0801         1048576 sda1 1fcbc57f-4bfc-4c2b-91a3-9c84fbcd9af1  0802        30720000 sda2 084917b7-8be2-4e86-838d-f771a9902e08  0803        15360000 sda3 180053b6-6697-4f4c-b331-4925773197ff  0804        54730752 sda4 b67dfc6e-d06f-4b11-bd52-96c09163aca9  0805        15360000 sda5 6d0d537c-3107-4057-a57b-5379a0cd8e31No filesystem could mount root, tried:  btrfs
>> [    1.077120] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)
>>
>> Something seems broken in the patches regarding the console or newline logic.
>
> (Just to mention it: I did do quite some testing, but this case must have
> escaped me.)

Yeah, don't tell me, it was not really fun to discover all the weird
edges here because nobody wants to have rules. :)

> Please, try the patch below on top of everything. If this works, I'll prepare
> a -v2 where everything is sorted into the correct patches.

Looks all fine now.

Kay
