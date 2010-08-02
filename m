Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0HBSjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:39:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0HBSjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:39:09 -0400
Subject: Re: [RFC] BTS based perf user callchains
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Markus Metzger <markus.t.metzger@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100802183506.GA8962@nowhere>
References: <20100802183506.GA8962@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 20:38:52 +0200
Message-ID: <1280774332.1923.245.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 20:35 +0200, Frederic Weisbecker wrote:
> I'm not even sure that will work. Also, while looking at the BTS implementation
> in perf, I see we have one BTS buffer per cpu. But that doesn't look right as
> the code flow is not linear per cpu but per task. Hence I suspect we need
> one BTS buffer per task. But may be someone tried that and encountered a
> problem? 

IIRC we flush the buffer when we deschedule the counter.
