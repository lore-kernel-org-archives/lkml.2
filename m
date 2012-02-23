Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2BWITb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:19:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2BWITa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:19:30 -0500
Message-ID: <4F45F742.1060605@cn.fujitsu.com>
Date: Thu, 23 Feb 2012 16:22:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>
In-Reply-To: <20120221211938.GE12236@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 16:17:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 16:17:46,
	Serialize complete at 2012-02-23 16:17:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following is a "best practices" document on using cgroups.
> 
>   http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
> 
> To me, it seems to demonstrate the rather ugly situation that the
> current cgroup is providing.  Everyone should tip-toe around cgroup
> hierarchies and nobody has full knowledge or control over them.
> e.g. base system management (e.g. systemd) can't use freezer or task
> counter as someone else might want to use it for different hierarchy
> layout.
> 

This issue still exists if we allow a single hierarchy only, right?
Different cgroup users/applications have to struggle not to step
on each other's toe.
