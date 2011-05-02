Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab1EBSqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:46:36 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58146 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab1EBSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:46:34 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home> <87y62pf9xg.fsf@devron.myhome.or.jp>
	<87r58hf866.fsf@devron.myhome.or.jp>
	<20110502170122.GA14096@eazy.amigager.de>
Date: Tue, 03 May 2011 03:46:31 +0900
In-Reply-To: <20110502170122.GA14096@eazy.amigager.de> (Tino Keitel's message
	of "Mon, 2 May 2011 19:01:22 +0200")
Message-ID: <87k4e9ey9k.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel <tino.keitel@gmx.de> writes:

> On Tue, May 03, 2011 at 00:12:33 +0900, OGAWA Hirofumi wrote:
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>> 
>> > Tino Keitel <tino.keitel@tikei.de> writes:
>> >
>> >> On Mon, May 02, 2011 at 08:49:45 +0200, Tino Keitel wrote:
>> >>> Hi,
>> >>> 
>> >>> when I insert a CF or SD card from my cameras into the USB card reader,
>> >>> I get the attached kernel oops. This is reproducible and did not happen
>> >>> with 2.6.38.
>> >>
>> >> Forgot to mention: the bug occurs with 2.6.39-rc5.
>> >
>> > There is no related change in fs/fat after 2.6.38. So, the cause would
>> > be other area. Anyway, I'll see detail a bit.
>> 
>> BTW, is this reproducible? And could you send .config both of 2.6.38 and
>> 2.6.39-rc5?
>
> Yes, it is reproducible. It happens with a CF card from a Canon DSLR as
> well as with a SD card from a little Fuji cam. Configs are attached.

.config didn't have interest part for now. Could you send another oops,
and vfat.ko, fat.ko? I'd like to see more detail by assembler, current
oops is unclear...

And if possible, git bisect is appreciate.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
