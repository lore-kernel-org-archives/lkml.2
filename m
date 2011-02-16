Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1BPVlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:41:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1BPVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:41:05 -0500
Subject: Re: Porting "jump labels" to userspace
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au
In-Reply-To: <alpine.LFD.2.00.1102162143430.2701@localhost6.localdomain6>
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb>
	 <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com>
	 <1297853778.3224.90.camel@springer.wildebeest.org>
	 <20110216185056.CAD7B1806E0@magilla.sf.frob.com>
	 <20110216200034.GA6066@Krystal>
	 <20110216200449.1EB9618020E@magilla.sf.frob.com>
	 <4D5C30D8.8070107@caviumnetworks.com> <20110216203953.GB2015@Krystal>
	 <alpine.LFD.2.00.1102162143430.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 22:42:09 +0100
Message-ID: <1297892529.5226.543.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 21:45 +0100, Thomas Gleixner wrote:

> We talk about 500 lines of code, where half of it is modules specific
> and the whole thing is full of kernelims. IMNSHO, that's faster
> reimplemented from scratch than writing all the mails and get the
> authors to sign off on the license change.

That and I'm not going to consent with an LGPL license, I'm an avid
GPLv2 fan as various people already know ;-)

