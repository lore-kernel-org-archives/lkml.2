Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0JUHk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:40:56 -0400
Received: from fep19.mx.upcmail.net ([62.179.121.39]:45597 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab0JUHky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:40:54 -0400
X-SourceIP: 80.56.199.130
Subject: Re: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4CBFECF6.8040304@gmail.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	 <4CBF0FB7.3000602@gmail.com> <20101020155406.GC5387@nowhere>
	 <4CBF12D4.4070207@gmail.com> <1287591225.3488.29.camel@twins>
	 <4CBFECF6.8040304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 09:40:46 +0200
Message-ID: <1287646846.3488.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=XCVXOBqlCPU5N10w5kBzDuedWCKZPpIJSEs1endkdVI= c=1 sm=0 a=bL8u2p6j2agA:10 a=IkcTkHD0fZMA:10 a=uHWHkVGNgXo5t1tDT0UA:9 a=jfcG8ALq3HC4xlmnROy_U85ctvQA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 09:34 +0200, Jiri Slaby wrote:
> On 10/20/2010 06:13 PM, Peter Zijlstra wrote:
> > On Wed, 2010-10-20 at 18:03 +0200, Jiri Slaby wrote:
> >> I applied the patch and got another BUG:
> > 
> > I don't think it applies on its own.. please use -tip or -next.
> 
> Ok, it works in mmotm 2010-10-20-15-01.

Awesome, thanks for testing!

