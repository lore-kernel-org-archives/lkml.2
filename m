Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2DEE6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:58:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50284 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2DEE6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:58:52 -0400
Date: Wed, 4 Apr 2012 21:58:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333601231.7783.31.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Mike Galbraith wrote:

> Below is user interface only patchlet.  I find it cleaner than the
> cpuset,cpu variant, but don't have strong feelings either way.
> 
> If this one don't fly, I'll just declare buglet immortal, he ain't worth
> near the electrons he's already wasted ;-) 
> 

Why can't you simply propose the cpusets version that both Paul and I 
liked?  There's _no_ reason to do this for every cgroup, current or 
future.
