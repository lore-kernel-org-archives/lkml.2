Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1KVCZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:25:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1KVCZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:25:48 -0500
Message-ID: <4ECB089C.3080208@cn.fujitsu.com>
Date: Tue, 22 Nov 2011 10:27:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: paul@paulmenage.org, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org,
        oleg@redhat.com, kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: stable threadgroup during attach & subsys
 methods consolidation
References: <1320191193-8110-1-git-send-email-tj@kernel.org> <20111121220719.GP25776@google.com>
In-Reply-To: <20111121220719.GP25776@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-22 10:25:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-22 10:25:34,
	Serialize complete at 2011-11-22 10:25:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Tue, Nov 01, 2011 at 04:46:23PM -0700, Tejun Heo wrote:
>> This patchset is combination of the following two patchsets.
>>
>>  [1] cgroup: extend threadgroup locking
>>  [2] cgroup: introduce cgroup_taskset and consolidate subsys methods, take#2
> 
> Li, do you agree with the proposed patches?  If so, I'll wait for
> Frederic's response, repost updated series and merge it into the
> cgroup tree.
> 

I remember I've acked both patchsets in your earlier post. :)

--
Li Zefan
