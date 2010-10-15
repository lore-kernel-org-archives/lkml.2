Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0JORkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:40:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:46602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0JORkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:40:01 -0400
Subject: Re: [PATCH] perf_events: fix transaction recovery in
 group_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <AANLkTimGyMRHEDxBwgCEyQrfjSrp9tFj1J-xHpY0=f1u@mail.gmail.com>
References: <4cb86b4c.41e9d80a.44e9.3e19@mx.google.com>
	 <1287163797.1998.107.camel@laptop>
	 <AANLkTimGyMRHEDxBwgCEyQrfjSrp9tFj1J-xHpY0=f1u@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 19:39:47 +0200
Message-ID: <1287164387.1998.109.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 19:34 +0200, Stephane Eranian wrote:
> 
> > Yes, makes sense.. I'm a bit hesitant to slap a -stable tag on it due to
> > its size,.. Ingo, Paulus?
> >
> I was worried about the size too but I could not figure out another
> smaller way of doing this. An alternative would be to pass an
> extra argument to the function and call it twice. 

I think the current approach is fine, just being paranoid about
unintentional breakage..

I guess we should cook it a while before offering it to -stable.

