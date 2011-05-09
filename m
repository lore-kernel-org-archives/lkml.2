Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1EIDNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:13:24 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:51574 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1EIDNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:13:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home> <87y62pf9xg.fsf@devron.myhome.or.jp>
	<87r58hf866.fsf@devron.myhome.or.jp>
	<20110502170122.GA14096@eazy.amigager.de>
	<87k4e9ey9k.fsf@devron.myhome.or.jp> <20110502203327.GA19507@mac.home>
	<87bozkg3ng.fsf@devron.myhome.or.jp>
	<8762psfwew.fsf@devron.myhome.or.jp>
	<87vcxsegbo.fsf@devron.myhome.or.jp>
	<87r58geejh.fsf@devron.myhome.or.jp>
	<87k4e8ecm4.fsf@devron.myhome.or.jp> <874o54ip8m.fsf@rustcorp.com.au>
Date: Mon, 09 May 2011 12:13:18 +0900
In-Reply-To: <874o54ip8m.fsf@rustcorp.com.au> (Rusty Russell's message of
	"Mon, 09 May 2011 11:56:01 +0930")
Message-ID: <8762pk36sx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Tue, 03 May 2011 11:34:11 +0900, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>> > Hm. It seems to be 0x80 was gone somehow. If I added 0x80 at 0x8661, it
>> > seems to be sane code.
>> >
>> >   20:	74 51                	je     73 <a+0x73>
>> >   22:	49 c7 c6 d8 91 13 a0 	mov    $0xffffffffa01391d8,%r14
>> >   29:	b2 b6                	mov    $0xb6,%dl
>> >   2b: 80 3d fc 9b 00 00 00 cmpb $0x0,0x9bfc(%rip) <- here is
>> > 0x8661
>> >   32:	74 3f                	je     73 <a+0x73>
>> >   34:	49 8d 44 24 08       	lea    0x8(%r12),%rax
>> 
>> Code: fd ff ff 0f 1f 80 00 00 00 00 83 ca 01 89 93 10 02 00 00 ba ff
>> 01 00 00 41 f6 85 96 00 00 00 02 74 51 49 c7 c6 d8 91 13 a0 b2 b6 3d
>> fc 9b 00 00 00 74 3f 49 8d 44 24 08 48 89 44 24 08 eb 18 
>
> How strange, but if this can't be reproduced with a rebuilt kernel I'm
> tempted to put it down to corruption in the module somehow...

I just bridged the bug report, so not pretty sure though. It sounds like
to be fixed by rebuilding kernel.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
