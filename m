Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1D2ICo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:02:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37754 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537Ab1D2ICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:02:41 -0400
Date: Fri, 29 Apr 2011 09:02:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] mm: Delete non-atomic mm counter implementation
Message-ID: <20110429090236.6f2d8e61@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110428090857.24de6532.kamezawa.hiroyu@jp.fujitsu.com>
References: <1303914965-868-1-git-send-email-matt@console-pimps.org>
	<20110428090857.24de6532.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 09:08:57 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> now mm_counters are update in per-thread and removing non-atomic
> will not have big impact in performance, I hope. 
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

Note that this patch doesn't enable per-thread counters for the
non-USE_SPLIT_PTLOCKS case; SPLIT_RSS_COUNTING is still only enabled if
USE_SPLIT_PTLOCKS is on.

-- 
Matt Fleming, Intel Open Source Technology Center
