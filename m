Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0F2MFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:05:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44510 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0F2MFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:05:10 -0400
To: Jens Axboe <axboe@kernel.dk>
CC: miklos@szeredi.hu, xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <4C29D5B9.9040401@kernel.dk> (message from Jens Axboe on Tue, 29
	Jun 2010 13:15:05 +0200)
Subject: Re: [PATCH 0/3] splice fixes
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu> <4C29D5B9.9040401@kernel.dk>
Message-Id: <E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jun 2010 14:05:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010, Jens Axboe wrote:
> On 2010-06-29 13:08, Miklos Szeredi wrote:
> > These patches fix bugs that affect real-world users of splice(2) and
> > sendfile(2) interfaces.
> > 
> > Not sure if some or all of them are appropriate for 2.6.35 and/or
> > -stable?
> 
> I think that 1-2 should go into 2.6.35 directly, and 3 for .36 with
> a stable backport as well. Agree?

Yes, sounds good.

Thanks,
Miklos
