Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1FJJRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:17:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1FJJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:17:51 -0400
Date: Fri, 10 Jun 2011 05:17:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110610091747.GC4183@redhat.com>
References: <1307616577-6101-1-git-send-email-tm@tao.ma>
 <20110609141451.GD29913@redhat.com>
 <4DF0DD0F.8090407@tao.ma>
 <20110609153738.GF29913@redhat.com>
 <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 09:19:12AM +0800, Shaohua Li wrote:

[..]
> > If there is no major advantage of draining sync requests before async
> > is dispatched, I think this should be an easy fix.
> I thought this is to avoid sync latency if we switch from an async
> queue to sync queue later.

Is it about the sync request latency which has already been dispatched? I 
really wish that driver and disk should do some prioritazation for reads
here and CFQ does not have to jump through hoops like drain sync requests
before async requests are dispatched.

Thanks
Vivek
