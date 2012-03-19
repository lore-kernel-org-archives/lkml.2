Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2CSCNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:13:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45567 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2CSCNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:13:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6695EC.2060208@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 11:11:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 02/10] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1331919570-2264-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/17 2:39), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Using VM_FAULT_* codes with ERR_PTR will require us to make sure
> VM_FAULT_* values will not exceed MAX_ERRNO value.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


Is this a bug fix ?
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

