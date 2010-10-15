Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0JOOIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:08:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:50400 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0JOOIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:08:50 -0400
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20101015140437.GD5334@nowhere>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.609332490@chello.nl>  <20101015140437.GD5334@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 16:08:27 +0200
Message-ID: <1287151707.29097.1517.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:04 +0200, Frederic Weisbecker wrote:
> On Thu, Oct 14, 2010 at 10:34:11PM +0200, Peter Zijlstra wrote:
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


Shall we get it compiling first? ;-)
