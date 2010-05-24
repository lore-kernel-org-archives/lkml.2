Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0EXHtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:49:43 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44643 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0EXHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:49:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: mtk.manpages@gmail.com
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
	<alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
	<20100522223838.ebca396a.akpm@linux-foundation.org>
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com>
	<20100523070917.GO23411@kernel.dk>
	<AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com>
	<20100523174706.GP23411@kernel.dk>
	<87632e846m.fsf@devron.myhome.or.jp>
	<20100524070416.GQ23411@kernel.dk>
	<AANLkTikwTa16lDh87zkI-L9SaI9jG1_eqZuo4z7dj2qP@mail.gmail.com>
Date: Mon, 24 May 2010 16:49:40 +0900
In-Reply-To: <AANLkTikwTa16lDh87zkI-L9SaI9jG1_eqZuo4z7dj2qP@mail.gmail.com>
	(Michael Kerrisk's message of "Mon, 24 May 2010 09:28:54 +0200")
Message-ID: <877hmt4u3v.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> writes:

> Actually, SO_*BUF is pretty weird. It returns double what was
> supplied. It's not simply a matter of rounding up: it always doubles
> what was supplied.

Yes. However, well, I'm feeling it also is implementation detail of "at
least". :)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
