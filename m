Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644Ab2EQK6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:58:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46435 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760981Ab2EQK6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:58:06 -0400
Message-ID: <4FB4D945.7060108@parallels.com>
Date: Thu, 17 May 2012 14:56:05 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 6/6] mm: memcg: print statistics from live counters
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org> <1337018451-27359-7-git-send-email-hannes@cmpxchg.org> <20120516160131.fecb5ddf.akpm@linux-foundation.org> <4FB43FDB.6050300@jp.fujitsu.com>
In-Reply-To: <4FB43FDB.6050300@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 04:01 AM, KAMEZAWA Hiroyuki wrote:
> Hm...sorry. I(fujitsu) am now considering to add meminfo for memcg...,
>
> add an option to override /proc/meminfo if a task is in container or
> meminfo file somewhere.
> (Now, we cannot trust /usr/bin/free, /usr/bin/top etc...in a container.)

Yes, and all the previous times I tried to touch those, I think the 
general agreement was to come up with some kind of fuse overlay that 
would read information available from the kernel, and present it 
correctly formatted through bind-mounts on the files of interest.

But that's mainly because we never reached agreement on how to make that 
appear automatically from such tasks
