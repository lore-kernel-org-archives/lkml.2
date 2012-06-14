Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab2FNEJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:09:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50566 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2FNEJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:09:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD96370.2020708@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 13:07:12 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 19:27), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> This patchset add the charge and uncharge routines for hugetlb cgroup.
> We do cgroup charging in page alloc and uncharge in compound page
> destructor. Assigning page's hugetlb cgroup is protected by hugetlb_lock.
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


