Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0JTQNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:13:52 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:62177 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0JTQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:13:51 -0400
X-SourceIP: 80.56.199.130
Subject: Re: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4CBF12D4.4070207@gmail.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	 <4CBF0FB7.3000602@gmail.com> <20101020155406.GC5387@nowhere>
	 <4CBF12D4.4070207@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 18:13:45 +0200
Message-ID: <1287591225.3488.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BBXmjR/jrMMj1wHBsuD7Cdv69cLzNztNz9uR8CXiauo= c=1 sm=0 a=bL8u2p6j2agA:10 a=IkcTkHD0fZMA:10 a=DjaVtmbxCgh_SYXiHkQA:9 a=yRc02qnL_HFdtm4vv0944Ln_-ysA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 18:03 +0200, Jiri Slaby wrote:
> I applied the patch and got another BUG:

I don't think it applies on its own.. please use -tip or -next.

