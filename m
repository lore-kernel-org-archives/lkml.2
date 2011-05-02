Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab1EBOei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:34:38 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55574 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab1EBOeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:34:37 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home>
Date: Mon, 02 May 2011 23:34:35 +0900
In-Reply-To: <20110502065529.GA12397@mac.home> (Tino Keitel's message of "Mon,
	2 May 2011 08:55:29 +0200")
Message-ID: <87y62pf9xg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel <tino.keitel@tikei.de> writes:

> On Mon, May 02, 2011 at 08:49:45 +0200, Tino Keitel wrote:
>> Hi,
>> 
>> when I insert a CF or SD card from my cameras into the USB card reader,
>> I get the attached kernel oops. This is reproducible and did not happen
>> with 2.6.38.
>
> Forgot to mention: the bug occurs with 2.6.39-rc5.

There is no related change in fs/fat after 2.6.38. So, the cause would
be other area. Anyway, I'll see detail a bit.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
