Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0KIFdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:33:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58768 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0KIFdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:33:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Luke Hutchison <luke.hutch@gmail.com>
Subject: Re: "BUG: soft lockup - CPU#0 stuck for 61s! [kswapd0:184]"
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTimXSSU7Mc05URg3HsONC4iyDTMVJdRxvQ1fNntH@mail.gmail.com>
References: <AANLkTimXSSU7Mc05URg3HsONC4iyDTMVJdRxvQ1fNntH@mail.gmail.com>
Message-Id: <20101109142733.BC69.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 14:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I just wanted to report a bug upstream that is affecting the latest
> versions of at least both Fedora and Ubuntu. CPUs somehow lock up
> under load, producing errors of the form "BUG: soft lockup - CPU#0
> stuck for 61s! [kswapd0:184]"
> 
> The Fedora Bug report is here:
> https://bugzilla.redhat.com/show_bug.cgi?id=649694 -- however you can
> find lots of references to the error message on other distributions
> (including Ubuntu) by googling  "bug soft lockup cpu stuck".
> 
> Lockups seem to happen on server-class hardware under heavy loads when
> the machine is swapping.  This can lead to the entire machine locking
> up in some reported cases (although so far only individual CPUs seem
> to have locked up in my case, not the entire machine).  The point at
> which the CPU hangs varies -- see the dmesg output I attached to the
> Fedora bug report above.
> 
> My machine is a 12-way Xeon X5680 system with ext3, AFS and XFS
> filesystems (XFS is running on hardware RAID).  Please let me know if
> you need other info that would be helpful to diagnosing the problem.

AFAIK, This isssue was already fixed by Mel.

http://kerneltrap.org/mailarchive/linux-kernel/2010/10/27/4637977



