Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2LRPR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:17:26 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:42049 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2LRPRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:17:24 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch 3/7] mm: vmscan: clarify how swappiness, highest
 priority, memcg interact
Thread-Topic: [patch 3/7] mm: vmscan: clarify how swappiness, highest
 priority, memcg interact
Thread-Index: AQHN3II/O6dqwebIPkiSLfmFB0XPrJgeqxJQ
Date: Tue, 18 Dec 2012 15:16:22 +0000
Message-ID: <8631DC5930FA9E468F04F3FD3A5D007214AD86F1@USINDEM103.corp.hds.com>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
 <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-18_05:2012-12-18,2012-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212180103
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 01:12 PM, Johannes Weiner wrote:
> A swappiness of 0 has a slightly different meaning for global reclaim 
> (may swap if file cache really low) and memory cgroup reclaim (never 
> swap, ever).
> 
> In addition, global reclaim at highest priority will scan all LRU 
> lists equal to their size and ignore other balancing heuristics.
> UNLESS swappiness forbids swapping, then the lists are balanced based 
> on recent reclaim effectiveness.  UNLESS file cache is running low, 
> then anonymous pages are force-scanned.
> 
> This (total mess of a) behaviour is implicit and not obvious from the 
> way the code is organized.  At least make it apparent in the code flow 
> and document the conditions.  It will be it easier to come up with 
> sane semantics later.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Hmmm, my company's mail server is in trouble... The mail I sent
yesterday has not been delivered yet.

Anyway, this is good for me.
Thanks!

Reviewed-by: Satoru Moriya <satoru.moriya@hds.com>
