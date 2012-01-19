Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2ASHYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:24:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2ASHYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:24:00 -0500
Message-ID: <4F17C5A6.50501@cn.fujitsu.com>
Date: Thu, 19 Jan 2012 15:26:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [RFC] splitting cgroup.c
References: <4F177C67.6070907@cn.fujitsu.com> <20120119022401.GH21533@google.com>
In-Reply-To: <20120119022401.GH21533@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 15:22:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 15:22:48,
	Serialize complete at 2012-01-19 15:22:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So I think for the sake of readability and maintainability, we'd
>> better split cgroup.c into smaller pieces:
> 
> I agree that splitting is necessary but IMHO splitting usually tends
> to go too far.  Maybe we can split it into two and think about further
> splitting later on?  e.g. internal logic vs. userland interfacing.
> 

This isn't feasible. The feasible way is to split by functionality,
which I think was the way taken by perf developers.
