Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0GWJL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:11:59 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:42867 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab0GWJL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:11:58 -0400
X-AuditID: 1209190e-b7bbeae000000a09-3b-4c495cdec594
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100723144549.88BA.A69D9226@jp.fujitsu.com>
Date: Fri, 23 Jul 2010 05:11:50 -0400
Cc: Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4E28BC9A-BB77-45BC-862A-29601EF4AE2C@mit.edu>
References: <20100722054957.GA11670@infradead.org> <20100723011315.GC16373@thunk.org> <20100723144549.88BA.A69D9226@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2010, at 1:47 AM, KOSAKI Motohiro wrote:

> 
> I'm not familiar ext4 so much. but you patch seems very nice!
> thank you :)

So, can someone confirm that this fixes the NULL pointer dereference?  The patch itself makes sense, and it doesn't change the tracepoint output, so I'm inclined to include it, but I haven't been able to reproduce the failure myself using the reproduction recipe given at the beginning of this thread --- and I'd feel much better if someone who has been able to reproduce the crash can confirm this fixes things for them.

Thanks,

-- Ted
 