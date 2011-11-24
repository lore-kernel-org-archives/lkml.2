Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1KXCvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:51:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1KXCvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:51:53 -0500
Message-ID: <4ECDB10E.1080007@cn.fujitsu.com>
Date: Thu, 24 Nov 2011 10:50:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com> <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com> <4EC62AEA.2030602@cn.fujitsu.com> <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com> <4ECC5FC8.9070500@cn.fujitsu.com> <alpine.DEB.2.00.1111221902300.30008@chino.kir.corp.google.com> <4ECC7B1E.6020108@cn.fujitsu.com> <alpine.DEB.2.00.1111222210341.21009@chino.kir.corp.google.com> <4ECCA578.6020700@cn.fujitsu.com> <alpine.DEB.2.00.1111231425030.5261@chino.kir.corp.google.com> <4ECD9D43.6090202@cn.fujitsu.com> <alpine.DEB.2.00.1111231751480.9042@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111231751480.9042@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 10:51:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 10:51:36,
	Serialize complete at 2011-11-24 10:51:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 17:52:08 -0800 (pst), David Rientjes wrote:
> On Thu, 24 Nov 2011, Miao Xie wrote:
> 
>> Memory compaction will see an empty nodemask and do nothing, and then
>> we may fail to get several contiguous pages.
>>
> 
> Where do we rely on a consistent nodemask for memory compaction?

Maybe I am overcautious.
