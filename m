Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2BEEpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:45:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59007 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2BEEpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:45:43 -0500
MIME-Version: 1.0
In-Reply-To: <201202041536.52189.toralf.foerster@gmx.de>
References: <201202041109.53003.toralf.foerster@gmx.de>
	<20120204133331.GA13223@sig21.net>
	<201202041536.52189.toralf.foerster@gmx.de>
Date: Sun, 5 Feb 2012 12:45:40 +0800
Message-ID: <CAJd=RBC-aceg6JUzGEfD3hcwv+0yd2M_N9kpS0v-JDMMKFaj_Q@mail.gmail.com>
Subject: Re: swap storm since kernel 3.2.x
From: Hillf Danton <dhillf@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/4 Toralf Förster <toralf.foerster@gmx.de>:
>
> Johannes Stezenbach wrote at 14:33:31
>> On Sat, Feb 04, 2012 at 11:09:52AM +0100, Toralf Förster wrote:
>> > Within the last few weeks I'm observing sometimes a swap storm at my
>> > ThinkPad while compiling/installing new packages at my Gentoo Linux -
>> > the load is often something like :
>> >
>> > Load avg: 13.6, 20.6, 20.9
>> >
>> > I'm wondering whether this is related to kernel 3.2.x /Gentoo specific or
>> > related to my system only.
>>
>> Do you happen to have CONFIG_DEBUG_OBJECTS enabled?  For me it
>> ate lots of memory with 3.2.2, easily visible in slabtop.
>>
>>
>> Johannes
>
> No, I've these settings :
>
> tfoerste@n22 ~ $ zgrep -e OBJ -e SLAB -e SLUB /proc/config.gz  | grep -v '#'
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> CONFIG_SLABINFO=y
>

Would you please try the patchset of Rik?

         https://lkml.org/lkml/2012/1/26/374

Good weekend
Hillf
