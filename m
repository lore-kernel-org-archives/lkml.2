Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0JONwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:52:22 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48326 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0JONwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:52:21 -0400
Subject: Re: [RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in
 hw_breakpoint creation
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20101015134659.GA5334@nowhere>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.391543667@chello.nl>  <20101015134659.GA5334@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 15:52:04 +0200
Message-ID: <1287150724.29097.1514.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 15:47 +0200, Frederic Weisbecker wrote:

> > +#define PERF_ATTACH_TASK	0x04
> 
> 
> 
> Thanks, the patch looks good.
> 
> I'm just not sure about the point of this flag...

Ah, see 6/7..
