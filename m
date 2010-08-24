Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab0HXIEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:04:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:04:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 16:59:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH] memcg: towards I/O aware memcg v5
Message-Id: <20100824165926.3d069341.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100824074617.GI4684@balbir.in.ibm.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100824074617.GI4684@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 13:16:17 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-20 18:55:52]:
> 
> > This is v5.
> > 
> > Sorry for delaying...but I had time for resetting myself and..several
> > changes are added. I think this version is simpler than v4.
> > 
> > Major changes from v4 is 
> >  a) added kernel/cgroup.c hooks again. (for b)
> >  b) make RCU aware. previous version seems dangerous in an extreme case.
> > 
> > Then, codes are updated. Most of changes are related to RCU.
> > 
> > Patch brief view:
> >  1. add hooks to kernel/cgroup.c for ID management.
> >  2. use ID-array in memcg.
> >  3. record ID to page_cgroup rather than pointer.
> >  4. make update_file_mapped to be RCU aware routine instead of spinlock.
> >  5. make update_file_mapped as general-purpose function.
> >
> 
> Thanks for being persistent, will review the patches with comments in
> the relevant patches. 
> 

Thank you. I may be able to post v6, tomorrow.

-Kame

