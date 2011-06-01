Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1FANuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab1FANuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:50:03 -0400
Message-ID: <4DE6436B.3080002@redhat.com>
Date: Wed, 01 Jun 2011 15:49:31 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        balbir@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com> <20110601123913.GC4266@tiehlicka.suse.cz>
In-Reply-To: <20110601123913.GC4266@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 02:39 PM, Michal Hocko wrote:
> I am not saying tha the change is bad, I like it, but I do not think it
> is a fix for potential race condition.
And yes, I agree that it is rather a workaround than real fix of race
condition which shouldn't exist in the first place. But giving my very
limited knowledge of cgroups and difficulty to reproduce the crash
after adding/enabling additional debugging, that patch is what
can fix the problem for now.
And maybe more experienced guys will look at the code and fix it
in the right way. Well at least I hope for that.
