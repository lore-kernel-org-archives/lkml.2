Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1ECVJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:09:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41087 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1ECVJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:09:44 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel paging request when inserting FAT32 formatted flash media
References: <20110502064945.GA12197@mac.home>
	<20110502065529.GA12397@mac.home> <87y62pf9xg.fsf@devron.myhome.or.jp>
	<87r58hf866.fsf@devron.myhome.or.jp>
	<20110502170122.GA14096@eazy.amigager.de>
	<87k4e9ey9k.fsf@devron.myhome.or.jp> <20110502203327.GA19507@mac.home>
	<87bozkg3ng.fsf@devron.myhome.or.jp>
	<8762psfwew.fsf@devron.myhome.or.jp>
	<871v0gfw9z.fsf@devron.myhome.or.jp> <20110503202208.GA5666@mac.home>
Date: Wed, 04 May 2011 06:09:40 +0900
In-Reply-To: <20110503202208.GA5666@mac.home> (Tino Keitel's message of "Tue,
	3 May 2011 22:22:08 +0200")
Message-ID: <8739kvlcdn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel <tino.keitel@tikei.de> writes:

> On Tue, May 03, 2011 at 09:44:08 +0900, OGAWA Hirofumi wrote:
>
> [...]
>
>> BTW, rebuilding from scratch make something difference?
>
> Hi,

Hi,

> I upgraded to current git (5933f2ae353a93b1d3b501bc63c925531849bbc7),
> and did a git clean -dfx. The rebuilt kernel now does not Oops anymore,
> with both the CF and the SD card. Could this be a glitch in the
> Makefile dependencies?

It's hard to say, the behavior is too strange, but I guess there is
possibility (to spot the cause, I think we have to checking binary. It
would need long time even if we want to do.).

If you want to check slightly, you can checkout previous commitid, then
rebuild and test.  If previous one worked well, it can be Makefile
dependencies (or something in build-toolchain if you upgraded after
test).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
