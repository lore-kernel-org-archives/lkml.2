Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0EXSMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:12:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:34375 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0EXSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:12:45 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
	<20100522223838.ebca396a.akpm@linux-foundation.org>
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com>
	<20100523070917.GO23411@kernel.dk>
	<AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com>
	<20100523174706.GP23411@kernel.dk>
	<87632e846m.fsf@devron.myhome.or.jp>
	<20100524070416.GQ23411@kernel.dk>
	<87bpc54u9w.fsf@devron.myhome.or.jp>
	<20100524171522.GT23411@kernel.dk>
Date: Tue, 25 May 2010 03:12:40 +0900
In-Reply-To: <20100524171522.GT23411@kernel.dk> (Jens Axboe's message of "Mon,
	24 May 2010 19:15:22 +0200")
Message-ID: <87d3wlw4mf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> > Isn't that pretty much what I described?
>> 
>> Yes, probably. Well, 120kb was still multiple of page size. :)
>
> It is, but 120KB/page_size is not (which is the power-of-2 of interest
> here).

Um... I have no interest whether rounded-up-size is power-of-2 or
not. Because it is implementation detail.

Anyway, we agreed with "in bytes" and "at least"? If so, I'm happy with
it, and I'm sorry if I was just noise.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
