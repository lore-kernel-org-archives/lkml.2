Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2EaG26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:28:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42923 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2EaG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:28:56 -0400
Date: Wed, 30 May 2012 23:28:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <4FC70E5E.1010003@gmail.com>
Message-ID: <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com>
 <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
 <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, KOSAKI Motohiro wrote:

> > An application should always know the cgroup that its attached to and be
> > able to read its state using the command that I gave earlier.
> 
> No. you don't need why userland folks want namespaces. Even though you don't
> need namespaces. It doesn't good reason to refuse another use case.
> 

This is tangent to the discussion, we need to revisit why an application 
other than a daemon managing a set of memcgs would ever need to know the 
information in /proc/meminfo.  No use-case was ever presented in the 
changelog and its not clear how this is at all relevant.  So before 
changing the kernel, please describe how this actually matters in a real-
world scenario.
