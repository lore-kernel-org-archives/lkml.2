Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab2CNVNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:13:13 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:48884 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab2CNVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:13:09 -0400
Date: Wed, 14 Mar 2012 21:13:02 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
In-Reply-To: <CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1203142101290.6232@diagnostix.dwd.de>
References: <20120312030412.375458948@fusionio.com> <alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de> <4F5EFEB6.4060402@kernel.org> <alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de> <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
 <alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de> <CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com> <alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de> <CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Shaohua Li wrote:

> Maybe the discard runs slow with small size request in the disk.
> please drop patch "blk: add plug for blkdev_issue_discard" and try again. Since
> we can't do merge, the plug just introduces latency.
>
Tried again without the patch applied, but there is only a very small
performance increase (520->600 agains 4000 fps without discard).

The benchmark creates lots of small files (2 KiB) and deletes them again.

> if it doesn't help, please capture a blktrace when you do the benchmark and
> send it to me.
>
Ok, I will do this tomorrow. Need some sleep :-)

Thanks for your work on supporting discard in MD!

Regards,
Holger
