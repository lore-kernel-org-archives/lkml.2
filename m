Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030463Ab2CGV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:29:23 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55692 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab2CGV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:29:20 -0500
Date: Wed, 7 Mar 2012 15:28:48 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <dsahern@gmail.com>, <fweisbec@gmail.com>,
        <yanmin_zhang@linux.intel.com>, <emunson@mgebm.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307152848.562c72f2@wrlaptop>
In-Reply-To: <1331153964.11248.362.camel@twins>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
	<20120306192912.59811e3e@wrlaptop>
	<20120307203725.GA4333@elte.hu>
	<1331153964.11248.362.camel@twins>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 21:59:24 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-03-07 at 21:37 +0100, Ingo Molnar wrote:
> >         size_needed = snprintf_size(...);
> 
> This would require 3 passes over the fmt+args, first to find the
> allocated size is insufficient, 2nd to compute the size, 3rd to fill
> buffer.
> 
> Whereas with the current "creative" API only 2 passes are needed.
> 
> I can imagine that back in the day of small memory and small CPU this
> was deemed important enough.

It occurs to me that I have seen this discussion, or a variant, before:

http://coding.derkeiler.com/Archive/C_CPP/comp.lang.c/2004-11/2332.html

In which people discuss the possible alternative return values at some
length.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
