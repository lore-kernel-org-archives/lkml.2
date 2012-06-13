Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2FMIRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:17:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:55713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2FMIRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:17:01 -0400
Message-ID: <1339575411.31548.107.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?Q?=27=E5=90=AB=E9=BB=9B=27?= <handai.szj@taobao.com>
Date: Wed, 13 Jun 2012 10:16:51 +0200
In-Reply-To: <004701cd4929$200d4600$6027d200$@net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
		 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
	 <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 22:55 -0700, Doug Smythies wrote:
> On my computer, and from a different thread from yesterday, I let
> the proposed "wang" patch multiple processes test continue for
> another 24 hours. 

So I got waiter_1.txt and load_180.txt and tried running it, but it
takes _forever_... is there anything I can run that gives a reasonable
output in say 30 minutes?


