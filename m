Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0EXRfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:35:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43879 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0EXRfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:35:53 -0400
Date: Mon, 24 May 2010 19:35:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: mtk.manpages@gmail.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100524173551.GU23411@kernel.dk>
References: <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> <20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> <20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> <20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24 2010, Michael Kerrisk wrote:
> > Right, that looks like a thinko.
> >
> > I'll submit a patch changing it to bytes and the agreed API and fix this
> > -Eerror. Thanks for your comments and suggestions!
> 
> Thanks. And of course you are welcome. (Please CC linux-api@vger on
> this patche (and all patches that change the API/ABI.)

The first change is this:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b

and the one dealing with the pages vs bytes API is this:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29

Not tested yet, will do so before sending in of course.

-- 
Jens Axboe

