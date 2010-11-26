Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0KZNgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:36:12 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:60119 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752479Ab0KZNgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:36:11 -0500
Subject: Re: [PATCH] perf: add GCC optimization to memory allocating
 functions
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290778040.2145.145.camel@laptop>
References: <1290777864.2373.2.camel@cowboy>
	 <1290778040.2145.145.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 10:36:02 -0300
Message-ID: <1290778562.2373.3.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 14:27 +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 10:24 -0300, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > We can benefit from the alloc_size attribute in xrealloc and zalloc.
> 
> What's this alloc_size attribute do?
> 
Quoting from http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html:

"The alloc_size attribute is used to tell the compiler that the function
return value points to memory, where the size is given by one or two of
the functions parameters. GCC uses this information to improve the
correctness of __builtin_object_size."

