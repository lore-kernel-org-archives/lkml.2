Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2FMV5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:57:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:40661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab2FMV5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:57:42 -0400
Message-ID: <1339624653.8980.76.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?Q?=27=E5=90=AB=E9=BB=9B=27?= <handai.szj@taobao.com>
Date: Wed, 13 Jun 2012 23:57:33 +0200
In-Reply-To: <000601cd4979$e1fda7a0$a5f8f6e0$@net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
			 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
		 <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net>
	 <1339575411.31548.107.camel@twins> <000601cd4979$e1fda7a0$a5f8f6e0$@net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 08:33 -0700, Doug Smythies wrote:
> 
> All that being said, what I typically do with a new code test is:
> 
> . select a known, previous bad operating point. For example 2
> processes, actual load average 0.30 (0.15 for each process) currently
> reporting ~1.5. 

OK, I'll try and apply this. Waiting 63 hours for feedback on patches is
something I'm not patient enough for.

Would this be: 

 ./waiter 2 900 230608 10000

I haven't even bothered reading the waiter proglet yet, but I did notice
the 'help' provided when started without arguments doesn't seem to
actually match what load_180 does.


