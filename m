Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1HXBa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:30:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab1HXBat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:30:49 -0400
Message-ID: <4E545467.9070202@cn.fujitsu.com>
Date: Wed, 24 Aug 2011 09:31:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        rjw@sisk.pl, paul@paulmenage.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/6] cgroup: subsys->attach_task() should be called after
 migration
References: <1314138000-2049-1-git-send-email-tj@kernel.org> <1314138000-2049-2-git-send-email-tj@kernel.org> <20110824003234.GB23979@somewhere>
In-Reply-To: <20110824003234.GB23979@somewhere>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-24 09:29:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-24 09:29:45,
	Serialize complete at 2011-08-24 09:29:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There have been a patch posted recently:
> 
>         "[PATCH][BUGFIX] cgroups: fix ordering of calls in cgroup_attach_proc"
> 
> that not only fixes that ordering but also only attach the task if the
> migration happened correctly (task not exited).
> 
> Can somebody queue it for 3.2 ?
> 

cgroup patches normally go through -mm tree.
