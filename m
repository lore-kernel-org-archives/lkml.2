Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2IIGai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 02:30:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56595 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2IIGag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 02:30:36 -0400
Date: Sat, 8 Sep 2012 23:30:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Message-ID: <20120909063031.GA15530@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
 <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
 <20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
 <20120908181107.GJ10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF51PY95Eg+DLhZ4ZRRNK0x9q+pOzrPfZbhTnPvk35j8PNg@mail.gmail.com>
 <20120908190204.GA12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF53Y9vAp2Eh3+2X=fLPYwq-DeW1dXTMmGJwoLRW6Bt_9xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53Y9vAp2Eh3+2X=fLPYwq-DeW1dXTMmGJwoLRW6Bt_9xQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Sep 09, 2012 at 12:09:58PM +0800, Lai Jiangshan wrote:
> >         mutex_lock(&pool->manager_mutex);
> >         if (worker_maybe_bind_and_lock(worker))
> >                 worker_clr_flags(worker, WORKER_UNBOUND);
> >         ret = true;
> >
> 
> 
> This code is correct. worker_maybe_bind_and_lock() can be called any time.
> but I like to call it only when it is really needed.

Ummm... that code is complex for no reason.  It isn't easier to read
or better in any way.  Given the recent exchanges, it seems our tastes
differ greatly.  Can you please just refresh the two patches as
requested and repost them on top of for-3.6-fixes?

Thanks.

-- 
tejun
