Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1LUSHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:07:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1LUSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:07:04 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=3YJMZR4FIEkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=X1Fof1SVcJgS15oOyOEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324490822.5916.109.camel@gandalf.stny.rr.com>
Subject: Re: oprofile patch broke s390 build in tip/perf/core
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 21 Dec 2011 13:07:02 -0500
In-Reply-To: <20111221175326.GM16765@erda.amd.com>
References: <1324488646.5916.107.camel@gandalf.stny.rr.com>
	 <20111221175326.GM16765@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 18:53 +0100, Robert Richter wrote:

> > The break is this:
> > 
> >   LD      .tmp_vmlinux1
> > arch/s390/oprofile/built-in.o: In function `oprofile_arch_exit':
> > (.text+0x3f52): undefined reference to `oprofile_timer_exit'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> 
> A fix is already in tip/perf/core:
> 
>  f8c8520 oprofile: Fix oprofile_timer_exit() breakage

Huh, I thought I did a recent pull from tip. But it came in with my pull
today.


Thanks,

-- Steve


