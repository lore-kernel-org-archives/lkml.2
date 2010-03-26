Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0CZD3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:29:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:38343 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab0CZD3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:29:01 -0400
Date: Fri, 26 Mar 2010 14:28:52 +1100
From: Neil Brown <neilb@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
Message-ID: <20100326142852.1d4f7b3b@notabene.brown>
In-Reply-To: <m1sk7npylk.fsf@fess.ebiederm.org>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<m1sk7npylk.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 20:10:15 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > This series tidies up the refcount of sysfs_dirents in sysfs,
> > using kref where appropriate and a new karef for s_active.
> > This achieves significant code simplification, especially the first
> > patch.
> >
> > This is in part inspired by http://lwn.net/Articles/336224/ :-)
> 
> Neil I would appreciate if you would cc' Tejun and myself on
> these kind of patches as we wrote the code and the best canidates
> to review it.
>

Yes, you are right of course.
I just pulled names out of MAINTAINERS figuring the maintainer would know
what best to do with the patch.

NeilBrown
