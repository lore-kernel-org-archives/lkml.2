Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0DUBDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:03:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35433 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0DUBDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:03:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 21 Apr 2010 09:59:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: repost - RFC [Patch] Remove
 "please try 'cgroup_disable=memory' option if you don't want memory cgroups"
 printk at boot time.
Message-Id: <20100421095935.54109d78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BCE4D34.5050200@cn.fujitsu.com>
References: <1271773587.28748.134.camel@dhcp-100-19-198.bos.redhat.com>
	<20100421092502.787371b5.kamezawa.hiroyu@jp.fujitsu.com>
	<4BCE4D34.5050200@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 08:56:20 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > My biggest concern is that we don't have man(5) cgroup as other file systems.
> > If we have man(5), the best place for this kind of information will be it.
> > I think most of users will never see kernel-parameter.txt ..
> > 
> > If usual distros are shipped with man(5) cgroup, I agree removing
> > this in upstream.
> > (We have man pages for libcgroup but not man(5) for cgroup file system.)
> > 
> > I'm sorry if I don't notice that the latest man package has cgroup section.
> > 
> 
> We have a man-page for cpuset, which was written by Paul Jackson,
> the author of cpuset.
> 
But there is no description about "cpuset can be mounted as cgroup".

Maybe there are no updates for 2 years even if it exists.

Thanks,
-Kame

