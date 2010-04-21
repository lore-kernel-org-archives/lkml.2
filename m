Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0DUAyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:54:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0DUAyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:54:44 -0400
Message-ID: <4BCE4D34.5050200@cn.fujitsu.com>
Date: Wed, 21 Apr 2010 08:56:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Larry Woodman <lwoodman@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: repost - RFC [Patch] Remove "please try 'cgroup_disable=memory'
 option if you don't want memory cgroups" printk at boot time.
References: <1271773587.28748.134.camel@dhcp-100-19-198.bos.redhat.com> <20100421092502.787371b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100421092502.787371b5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My biggest concern is that we don't have man(5) cgroup as other file systems.
> If we have man(5), the best place for this kind of information will be it.
> I think most of users will never see kernel-parameter.txt ..
> 
> If usual distros are shipped with man(5) cgroup, I agree removing
> this in upstream.
> (We have man pages for libcgroup but not man(5) for cgroup file system.)
> 
> I'm sorry if I don't notice that the latest man package has cgroup section.
> 

We have a man-page for cpuset, which was written by Paul Jackson,
the author of cpuset.
