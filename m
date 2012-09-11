Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2IKUve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:51:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52941 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925Ab2IKUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120911205027.GA25837@redhat.com>
References: <20120910223125.GC7677@google.com>
	<20120910223355.GD7677@google.com>
	<20120911182356.GR7677@google.com>
	<20120911205027.GA25837@redhat.com>
Date: Tue, 11 Sep 2012 13:51:30 -0700
X-Google-Sender-Auth: p8ouM7aVXXdn8mt2L2GUz6ncFfo
Message-ID: <CAOS58YPmrCrgdunsck78GTeGUCf9CBrS75BRt3wpQUfwMUGpsg@mail.gmail.com>
Subject: Re: [PATCH UPDATED RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 11, 2012 at 1:50 PM, Aristeu Rozanski <aris@redhat.com> wrote:
> Hi Tejun,
> On Tue, Sep 11, 2012 at 11:23:56AM -0700, Tejun Heo wrote:
>> +                     /* we're fully hierarchical iff root uses hierarchy */
>
> minor nit: s/iff/if/

That was intentional iff == if and only if. :)

Thanks.

-- 
tejun
