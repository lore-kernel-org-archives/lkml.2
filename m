Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1LLAuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:50:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53860 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1LLAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:50:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Dec 2011 09:49:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton (commit_signer:15/23=65%) 
	<akpm@linux-foundation.org>,
        Hugh Dickins (commit_signer:7/23=30%) <hughd@google.com>,
        Peter Zijlstra (commit_signer:4/23=17%) 
	<a.p.zijlstra@chello.nl>,
        Shaohua Li (commit_signer:3/23=13%) <shaohua.li@intel.com>
Subject: Re: [PATCH v3] mm: simplify find_vma_prev
Message-Id: <20111212094930.9d4716e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1323466526.27746.29.camel@joe2Laptop>
	<1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 17:48:40 -0500
kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 297c5eee37 (mm: make the vma list be doubly linked) added
> vm_prev member into vm_area_struct. Therefore we can simplify
> find_vma_prev() by using it. Also, this change help to improve
> page fault performance because it has strong locality of reference.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

