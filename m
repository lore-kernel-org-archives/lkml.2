Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1EXPM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:12:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:36166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1EXPMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:12:25 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 May 2011 17:11:54 +0200
Message-ID: <1306249914.18455.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
> As an aside, I also wasted 6 hours last night finding out that you don't 
> get signaled on overflow if you don't have a ring-buffer mmap()ed, even
> if you never read from the buffer and you only are interested in counting
> the number of overflows. 

That sounds like something we could fix, let me investigate.

>  I should stop complaining though or you'll
> start telling me to fix the documentation.  Which maybe I would do if I 
> didn't spend all my time writing code to reproduce problems in the perf 
> ABI for bisection purposes. 

Both are appreciated.
