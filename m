Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1EBPMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:12:39 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49654 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1EBPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:12:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home> <87y62pf9xg.fsf@devron.myhome.or.jp>
Date: Tue, 03 May 2011 00:12:33 +0900
In-Reply-To: <87y62pf9xg.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 02 May 2011 23:34:35 +0900")
Message-ID: <87r58hf866.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Tino Keitel <tino.keitel@tikei.de> writes:
>
>> On Mon, May 02, 2011 at 08:49:45 +0200, Tino Keitel wrote:
>>> Hi,
>>> 
>>> when I insert a CF or SD card from my cameras into the USB card reader,
>>> I get the attached kernel oops. This is reproducible and did not happen
>>> with 2.6.38.
>>
>> Forgot to mention: the bug occurs with 2.6.39-rc5.
>
> There is no related change in fs/fat after 2.6.38. So, the cause would
> be other area. Anyway, I'll see detail a bit.

BTW, is this reproducible? And could you send .config both of 2.6.38 and
2.6.39-rc5?

Page fault is in allocated area by module load, it sounds like
strange. Um...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
