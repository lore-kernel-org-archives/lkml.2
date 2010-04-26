Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0DZRZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:25:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58982 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0DZRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:25:30 -0400
Date: Mon, 26 Apr 2010 19:25:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blkio: Fix another BUG_ON() crash due to cfqq movement
	across groups
Message-ID: <20100426172528.GS27497@kernel.dk>
References: <20100421221906.GG3275@redhat.com> <20100426171800.GB3372@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426171800.GB3372@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26 2010, Vivek Goyal wrote:
> On Wed, Apr 21, 2010 at 06:19:06PM -0400, Vivek Goyal wrote:
> > o Once in a while, I was hitting a BUG_ON() in blkio code. empty_time was
> >   assuming that upon slice expiry, group can't be marked empty already (except
> >   forced dispatch).
> > 
> 
> Hi Jens,
> 
> Do you have any concerns with this patch? If not, can you please include
> it.

No it's fine, I have added it. Thanks!

-- 
Jens Axboe

