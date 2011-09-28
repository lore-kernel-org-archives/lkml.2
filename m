Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1I1GQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:16:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42326 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1I1GQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:16:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 15:15:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge
 at next window)
Message-Id: <20110928151558.dca1da5e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110915213305.GA26317@ca-server1.us.oracle.com>
References: <20110915213305.GA26317@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 14:33:05 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at next window)
> 
> (Note: V9->V10 only change is corrections in debugfs-related code/counters)
> 
> (Note to earlier reviewers:  This patchset was reorganized at V9 due
> to feedback from Kame Hiroyuki and Andrew Morton.  Additionally, feedback
> on frontswap v8 from Andrew Morton also applies to cleancache, to wit:
>  (1) change usage of sysfs to debugfs to avoid unnecessary kernel ABIs
>  (2) rename all uses of "flush" to "invalidate"
> As a result, additional patches (5of6 and 6of6) were added to this
> series at V9 to patch cleancache core code and cleancache hooks in the mm
> and fs subsystems and update cleancache documentation accordingly.)
> 

I'm sorry I couldn't catch following... what happens at hibernation ?
frontswap is effectively stopped/skipped automatically ? or contents of
TMEM can be kept after power off and it can be read correctly when
resume thread reads swap ?

In short: no influence to hibernation ?
I'm sorry if I misunderstand some.

Thanks,
-Kame

