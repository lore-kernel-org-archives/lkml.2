Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1I1C3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:29:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1I1C3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <m24o01khcp.fsf@firstfloor.org>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-7-git-send-email-glommer@parallels.com>
	<m24o01khcp.fsf@firstfloor.org>
Date: Wed, 28 Sep 2011 07:59:31 +0530
Message-ID: <CAKTCnzm_BVOLK8c0rwYoDJCs+-920DWjwHFoQtgriRTEXrGiqw@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
From: Balbir Singh <bsingharora@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 10:28 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Glauber Costa <glommer@parallels.com> writes:
>
>> This patch uses the "tcp_max_mem" field of the kmem_cgroup to
>> effectively control the amount of kernel memory pinned by a cgroup.
>>
>> We have to make sure that none of the memory pressure thresholds
>> specified in the namespace are bigger than the current cgroup.
>
> I noticed that some other OS known by bash seem to have a rlimit per
> process for this. Would that make sense too? Not sure how difficult
> your infrastructure would be to extend to that.

rlimit per process for tcp usage? Interesting, that reminds me, we
need to revisit rlimit (RSS) at some point

Balbir Singh
