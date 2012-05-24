Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2EXNVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:21:43 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47285 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2EXNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120523222242.GD3933@htj.dyndns.org>
References: <20120330223423.GJ28934@google.com> <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com> <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
 <20120518175548.GM19388@google.com> <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
 <20120523222242.GD3933@htj.dyndns.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 24 May 2012 15:21:20 +0200
Message-ID: <CA+1xoqdbtkC5Ue3s1qZHHJBLcj9a=djFDGny6AJJSV-pdn7mcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal optional
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com,
        Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:22 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Sasha.
>
> Does the following patch fix the problem you're seeing?
>
> Thanks.

Yup, that did the trick.

Thanks!
