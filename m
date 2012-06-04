Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab2FDPpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:45:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2FDPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:45:14 -0400
Date: Mon, 4 Jun 2012 11:06:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] block/throttle: Add IO throttled information in blkcg.
Message-ID: <20120604150645.GC3745@redhat.com>
References: <1337674236-2896-1-git-send-email-tm@tao.ma>
 <20120522111111.GE3045@redhat.com>
 <4FC4801F.7080100@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC4801F.7080100@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 03:51:59PM +0800, Tao Ma wrote:

[..]
> > Tejun has changed the code in this area and new code will allow you to
> > introduce this file in blk-throttle.c. All that code is sitting in Jens's
> > block tree.
> I am just trying to rebase my patch according to your suggestion, but I
> can't find the change you mentioned above. So could you please tell me
> where I can find the related change so that I can base my work on?
> 

Hi Tao,

Jens has now pushed the changes to Linus for 3.5 and Linus has merged all
the patches.

So look at block/blk-throttle.c and look for "throtl_files[]" where rest
of the throttle related cgroup files are declared.

Thanks
Vivek
