Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2E3NMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:12:12 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34564 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2E3NMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:12:10 -0400
Message-ID: <4FC61C20.8090402@parallels.com>
Date: Wed, 30 May 2012 17:09:52 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <20120530123406.GC25094@somewhere.redhat.com> <4FC614CF.5000906@parallels.com> <20120530131059.GE25094@somewhere.redhat.com>
In-Reply-To: <20120530131059.GE25094@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 05:11 PM, Frederic Weisbecker wrote:
> Can we have at least a comment in the code that explain the reasons of taking the
> owner rather than the task? It's not going to be very obvious to future reviewers.

Yes.
