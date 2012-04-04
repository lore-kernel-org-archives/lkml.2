Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2DDXKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:10:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43786 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2DDXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:10:30 -0400
Date: Wed, 4 Apr 2012 16:10:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizefan@huawei.com>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120404231025.GD2173@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
 <20120403184901.GC27794@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333506878.7433.2.camel@marge.simpson.net>
 <20120404230648.GB2173@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404230648.GB2173@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 04:06:48PM -0700, Tejun Heo wrote:
> On Wed, Apr 04, 2012 at 04:34:38AM +0200, Mike Galbraith wrote:
> > It looked to me like yes, because cgroup_attach_task() can be called
> > directly.  For the problem at hand, user script doing bad things, no,
> > it's not needed.
> 
> Then that's a kernel bug.  We're just trying to protect userland from
> shotting itself, so please just keep the one in the user-facing
> interface.

Ooh, and please use Li's new address - lizefan@huawei.com.

Thanks.

-- 
tejun
