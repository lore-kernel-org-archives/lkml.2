Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1BYRmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:42:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1BYRmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:42:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
In-Reply-To: Tejun Heo's message of  Friday, 25 February 2011 16:45:55 +0100 <20110225154555.GP24828@htj.dyndns.org>
References: <20110209141803.GH3770@htj.dyndns.org>
	<201102132325.55353.vda.linux@googlemail.com>
	<20110214151340.GP18742@htj.dyndns.org>
	<AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
	<20110214173012.GA18742@htj.dyndns.org>
	<AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
	<20110221151619.GM31267@htj.dyndns.org>
	<20110221152855.GA20769@redhat.com>
	<20110222162454.GB31267@htj.dyndns.org>
	<20110224210819.GB12258@redhat.com>
	<20110225154555.GP24828@htj.dyndns.org>
X-Windows: the defacto substandard.
Message-Id: <20110225174205.D0C711806E0@magilla.sf.frob.com>
Date: Fri, 25 Feb 2011 09:42:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, we are discussing these requests on archer,
> 
> Can we please do that on LKML?  It's a kernel change after all.

What's being discussed on the debugger list is batting around ideas of
what kinds of potential new features could be useful to the debugger.
No decisions about kernel issues are being made, and of course when it
comes to proposing specific kernel features, that would be discussed
here.  But the debugger community is who needs to discuss what they
would actually want and would actually make use of.  There is no point
in discussing the details of new ptrace features for the benefit of
the debugger on a kernel list before the debugger community has come
to some consensus about what they would really make use of.  It would
be counterproductive to start proposing and implementing random new
half-baked ideas in the kernel without first being sure that they are
things the debugger actually needs and the debugger developers will
actually do the work to exploit.  We've had enough of that already,
leading to the current morass of ill-specified features that don't
help the debugger people very much.


Thanks,
Roland
