Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1KXB1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:27:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1KXB1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:27:24 -0500
Message-ID: <4ECD9D43.6090202@cn.fujitsu.com>
Date: Thu, 24 Nov 2011 09:26:27 +0800
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
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com> <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com> <4EC62AEA.2030602@cn.fujitsu.com> <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com> <4ECC5FC8.9070500@cn.fujitsu.com> <alpine.DEB.2.00.1111221902300.30008@chino.kir.corp.google.com> <4ECC7B1E.6020108@cn.fujitsu.com> <alpine.DEB.2.00.1111222210341.21009@chino.kir.corp.google.com> <4ECCA578.6020700@cn.fujitsu.com> <alpine.DEB.2.00.1111231425030.5261@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111231425030.5261@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 09:27:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 09:27:08,
	Serialize complete at 2011-11-24 09:27:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 14:26:40 -0800 (pst), David Rientjes wrote:
> On Wed, 23 Nov 2011, Miao Xie wrote:
> 
>> That nodemask is also protected by get_mems_allowed().
>>
> 
> So what's the problem with the patch? 

Memory compaction will see an empty nodemask and do nothing, and then
we may fail to get several contiguous pages.


> Can I add your acked-by?

Sure, no problem.
