Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1JINsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:48:00 -0400
Received: from websrv.saout.de ([78.46.99.52]:41655 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1JINr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:47:59 -0400
Subject: Re: Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>, Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Jens@redhat.com,
        device-mapper@redhat.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <1318147923.22902.3.camel@localhost>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	 <20111008161421.GA5743@redhat.com>
	 <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
	 <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
	 <1318147923.22902.3.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 15:47:06 +0200
Message-ID: <1318168026.24616.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

> Also for the record: Jeff's patch causes other crashes on my machine
> (already posted), so while it might be fine from a technical point of
> view, it still has issues in its current form. Jeff is working on it.

I have to apologize.  Looks like I made a mistake the first time I tried
Jeff's patch.  Shaohua asked me to check again and this time the box
runs nicely.  I probably forgot something stupid like a modules_install.

The patch that Jeff posted is actually working.  Mea culpa.  Sorry for
the fuzz!

Thanks,
	Christophe


