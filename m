Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161156Ab2JXTHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:07:03 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45478 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120Ab2JXTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:07:00 -0400
Date: Wed, 24 Oct 2012 15:06:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN for
 PF_NOFREEZE or PF_FREEZER_SKIP tasks
Message-ID: <20121024190651.GC12182@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-5-git-send-email-tj@kernel.org>
 <20121022183453.GA24687@redhat.com>
 <20121022211822.GF5951@atj.dyndns.org>
 <20121023155533.GC16201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023155533.GC16201@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, Oct 23, 2012 at 05:55:33PM +0200, Oleg Nesterov wrote:
> > Ooh, ouch, definitely.  We should clear that.  Can you please make a
> > patch?
> 
> Sure... but what do you think is better?
> 
> I'd prefer to simply clear PF_NOFREEZE (without set_freezable), but
> obviously this doesn't look exactly right from cgroup_freezer pov.

I don't think it matters all that much.  It's a pretty special case.
Maybe define PF_CLEAR_ON_EXEC_MASK or something and just include
PF_NOFREEZE in it?

Thanks.

--
tejun
