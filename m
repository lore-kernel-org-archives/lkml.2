Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2EaGhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:37:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38007 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2EaGh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:37:28 -0400
Message-ID: <4FC711A5.4090003@gmail.com>
Date: Thu, 31 May 2012 02:37:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/31/12 2:28 AM), David Rientjes wrote:
> On Thu, 31 May 2012, KOSAKI Motohiro wrote:
>
>>> An application should always know the cgroup that its attached to and be
>>> able to read its state using the command that I gave earlier.
>>
>> No. you don't need why userland folks want namespaces. Even though you don't
>> need namespaces. It doesn't good reason to refuse another use case.
>>
>
> This is tangent to the discussion, we need to revisit why an application
> other than a daemon managing a set of memcgs would ever need to know the
> information in /proc/meminfo.  No use-case was ever presented in the
> changelog and its not clear how this is at all relevant.  So before
> changing the kernel, please describe how this actually matters in a real-
> world scenario.

Huh? Don't you know a meanings of a namespace ISOLATION? isolation mean,
isolated container shouldn't be able to access global information. If you
want to lean container/namespace concept, tasting openvz or solaris container
is a good start.

But anyway, I dislike current implementaion. So, I NAK this patch too.
