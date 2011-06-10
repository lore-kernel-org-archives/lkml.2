Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1FJJUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:20:48 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37799 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1FJJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:20:45 -0400
Message-ID: <4DF1E1EB.8010808@kernel.dk>
Date: Fri, 10 Jun 2011 11:20:43 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shaohua.li@intel.com>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com> <20110610091747.GC4183@redhat.com>
In-Reply-To: <20110610091747.GC4183@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-10 11:17, Vivek Goyal wrote:
> On Fri, Jun 10, 2011 at 09:19:12AM +0800, Shaohua Li wrote:
> 
> [..]
>>> If there is no major advantage of draining sync requests before async
>>> is dispatched, I think this should be an easy fix.
>> I thought this is to avoid sync latency if we switch from an async
>> queue to sync queue later.
> 
> Is it about the sync request latency which has already been dispatched? I 
> really wish that driver and disk should do some prioritazation for reads
> here and CFQ does not have to jump through hoops like drain sync requests
> before async requests are dispatched.

That would never work. Are you suggesting putting that logic in all
drivers? Or relying on hardware to get the fairness right? Not going to
happen.

-- 
Jens Axboe

