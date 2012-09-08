Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2IHRx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:53:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37511 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IHRx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:53:58 -0400
Date: Sat, 8 Sep 2012 10:53:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Message-ID: <20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
 <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 09, 2012 at 01:50:41AM +0800, Lai Jiangshan wrote:
> >> +             if (worker_maybe_bind_and_lock(manager))
> >> +                     worker_clr_flags(manager, WORKER_UNBOUND);
> >> +     }
> >> +}
> >
> > We can reuse busy_worker_rebind_fn(), right?
> 
> busy_worker_rebind_fn() releases the gcwq->lock. we can't release
> the lock here.

Why so?  Can you please elaborate?

Thanks.

-- 
tejun
