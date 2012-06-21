Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab2FUIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:48:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2FUIsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:48:38 -0400
Message-ID: <1340268506.21745.160.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Yong Zhang'" <yong.zhang0@gmail.com>,
        "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?Q?=27=E5=90=AB=E9=BB=9B=27?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Date: Thu, 21 Jun 2012 10:48:26 +0200
In-Reply-To: <002301cd4f64$17a055c0$46e10140$@net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
			 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
			 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
			 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy>
		 <1340097532.21745.19.camel@twins> <000001cd4e33$496f6c30$dc4e4490$@net>
	 <1340185528.21745.86.camel@twins> <002301cd4f64$17a055c0$46e10140$@net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 21:12 -0700, Doug Smythies wrote:
> Summary: Extremely good.

Finally... I was starting to question my sanity on this ;-)
