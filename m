Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2ASQnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:43:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2ASQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:43:05 -0500
Date: Thu, 19 Jan 2012 08:42:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] blkcg: use q and plid instead of opaque void *
 for blkio_group association
Message-ID: <20120119164259.GI5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-7-git-send-email-tj@kernel.org>
 <20120119140442.GA9582@redhat.com>
 <20120119155545.GD5198@google.com>
 <20120119161642.GC10908@redhat.com>
 <20120119162544.GG5198@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119162544.GG5198@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 08:25:44AM -0800, Tejun Heo wrote:
> Hmmm... we can add code to shoot down blkg's along with ioc's while
> preparing for elevator switch or just note the problem in the commit
> message and explain the problem is transitional.  I'll see how complex
> shooting down blkg's would be.

I think we need blkg shootdown on elv switch whether blkg is unified
or not.  I'll update the patch.  Thanks for pointing it out.

-- 
tejun
