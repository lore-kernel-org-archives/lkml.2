Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1KPA60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:58:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1KPA6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:58:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Nov 2011 09:57:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] Provide cpuacct functionality in cpu cgroup
Message-Id: <20111116095706.6304e695.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1321372757-1581-1-git-send-email-glommer@parallels.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 13:59:13 -0200
Glauber Costa <glommer@parallels.com> wrote:

> Hi,
> 
> This is an excerpt of the last patches I sent regarding cpu cgroup.
> It is mostly focused on cleaning up what we have now, so it can
> be considered largely preparation. As a user of the new organization
> of things, I am including cpuacct stats functionality in the end of
> the series. The files related to cpuusage are left to be sent in
> an upcoming series after this one is included.
> 
> Let me know if there is anything you'd like me to address.
> 

I'm sorry but let me several questions.

Why cpu cgroup but cpuacct cgroup ?
If scheduler stat is reported via cpu cgroup, it makes sense.
If user accounting information is reported via cpu cgroup, I feel it's strange.
Do you want to make cpuacct cgroup obsolete and merge 2 cgroups ?

What's relationship between this new counters and cpuacct cgroup ?
Aren't users confused ?

Please provide Documenation.

 
Thanks,
-Kame

