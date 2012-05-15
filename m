Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2EOLQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:16:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:47878 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2EOLQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:16:49 -0400
Message-ID: <1337080582.27694.40.camel@twins>
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Alex Shi <alex.shi@intel.com>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 13:16:22 +0200
In-Reply-To: <20120515103307.GB27153@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
	 <1336626013-28413-4-git-send-email-alex.shi@intel.com>
	 <20120510084213.GD30055@aftab.osrc.amd.com> <4FAB84B6.7060706@intel.com>
	 <4FAE18D0.6050001@intel.com> <20120513111328.GD28863@aftab.osrc.amd.com>
	 <4FB1AC03.2070407@intel.com> <20120515103307.GB27153@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 12:33 +0200, Borislav Petkov wrote:
> On Tue, May 15, 2012 at 09:06:11AM +0800, Alex Shi wrote:
> > Thanks for your input. but actually, total 3 labels doesn't looks
> > good. Maybe the following lines can meet your expectation.
> 
> Yeah, a bit better.

Wouldn't all this become much prettier if you rip out that multi-vector
stuff?
