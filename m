Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0EZQHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:07:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab0EZQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:07:04 -0400
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20100526160028.GC5299@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com>
	 <20100526095934.GA5311@nowhere> <1274880514.27810.454.camel@twins>
	 <20100526160028.GC5299@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 18:06:59 +0200
Message-ID: <1274890019.1674.1761.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 18:00 +0200, Frederic Weisbecker wrote:

> > You can also axe kernel/tracing/trace_sysprof.c and related bits.

> I'll do that too, but I 'll need Soeren's opinion before actually pushing it.

ISTR that the latest sysprof code uses the perf syscall.

