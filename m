Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2ASQRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:17:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36548 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2ASQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:17:47 -0500
Date: Thu, 19 Jan 2012 08:17:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] blkcg: use the usual get blkg path for root
 blkio_group
Message-ID: <20120119161742.GF5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-9-git-send-email-tj@kernel.org>
 <20120119144136.GB9582@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119144136.GB9582@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 09:41:36AM -0500, Vivek Goyal wrote:
> > This simplifies root blkg handling noticeably for cfq and will allow
> > further modularization of blkcg API.
> 
> Does this work if BLK_CGROUP=n?
> 
> I am trying to think that why did I keep allocating root cgroup statically
> for CFQ. May be the reason was that this group was present even if
> CFQ_GROUP_IOSCHED=n. There was other code which assumed a group to be
> always present and I did not want to put more #ifdef.
> 
> Anyway, if it works well, with BLK_CGROUP=n, then it is fine.

Right, it's currently broken but it shouldn't be too difficult to fix.
Will update the patch.

Thanks.

-- 
tejun
