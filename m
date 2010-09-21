Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0IUBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:05:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38282 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0IUBFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:05:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Sep 2010 10:00:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com, ebiederm@xmission.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFCv2][PATCH] add some drop_caches documentation and info
 messsge
Message-Id: <20100921100011.86f270de.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100916165047.DAD42998@kernel.beaverton.ibm.com>
References: <20100916165047.DAD42998@kernel.beaverton.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 09:50:47 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> 
> This version tones down the BUG_ON().  I also noticed that the
> documentation fails to mention that more than just the inode
> and dentry slabs are shrunk.
> 
> --
> 
> There is plenty of anecdotal evidence and a load of blog posts
> suggesting that using "drop_caches" periodically keeps your system
> running in "tip top shape".  Perhaps adding some kernel
> documentation will increase the amount of accurate data on its use.
> 
> If we are not shrinking caches effectively, then we have real bugs.
> Using drop_caches will simply mask the bugs and make them harder
> to find, but certainly does not fix them, nor is it an appropriate
> "workaround" to limit the size of the caches.
> 
> It's a great debugging tool, and is really handy for doing things
> like repeatable benchmark runs.  So, add a bit more documentation
> about it, and add a little KERN_NOTICE.  It should help developers
> who are chasing down reclaim-related bugs.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

thanks.

