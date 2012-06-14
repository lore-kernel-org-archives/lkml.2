Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2FNDNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:13:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44257 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2FNDNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:13:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD95665.5050300@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 12:11:33 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 08/15] hugetlb: Make some static variables global
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339583254-895-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 19:27), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> We will use them later in hugetlb_cgroup.c
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

