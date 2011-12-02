Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1LBAX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:23:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53182 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1LBAX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:23:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 09:22:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-Id: <20111202092217.50d72f71.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322751913.4699.19.camel@twins>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	<1322751913.4699.19.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 16:05:13 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-12-01 at 11:53 +0900, KAMEZAWA Hiroyuki wrote:
> > I tried to use jump_label for handling memcg's boot options which sets
> > global variable true/false and never changes after boot. And found jump_table
> > is larger than expected. This patch is a trial to allow to place jump_table
> > in .init section. How do you think ? 
> 
> I think its much saner to go help hnaz remove this shadow page table and
> thus the need for this stupid boot time param.
> 

Yes, that's an idea. But we also have another stupid shadow swap accounting
table.  This can be disabled at boot, too.

Thanks,
-Kame

