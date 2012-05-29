Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2E2QJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:09:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38985 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab2E2QJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:09:26 -0400
Message-ID: <4FC4F42D.6060601@parallels.com>
Date: Tue, 29 May 2012 20:07:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 19/28] slab: per-memcg accounting of slab caches
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-20-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290951520.4666@router.home>
In-Reply-To: <alpine.DEB.2.00.1205290951520.4666@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:52 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Glauber Costa wrote:
>
>> >  This patch charges allocation of a slab object to a particular
>> >  memcg.
> Ok so a requirement is to support tracking of individual slab
> objects to cgroups? That is going to be quite expensive since it will
> touch the hotpaths.
>

No, we track pages. But all the objects in the page belong to the same 
cgroup.


