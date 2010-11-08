Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0KHOO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:14:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0KHOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:14:27 -0500
Date: Mon, 8 Nov 2010 09:14:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
Message-ID: <20101108141420.GA12548@infradead.org>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20101108095610.GA22592@infradead.org>
 <5b55a1$ijitko@fmsmga002.fm.intel.com>
 <1289224934.12418.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289224934.12418.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:02:14AM -0500, Steven Rostedt wrote:
> I like the trace=on parameter much better. If that is set we could
> enable the tracepoints of that module at load time. I really do not want
> to export the function that was proposed in that patch.

Yes.  Adding generic support in the module loader to turn on tracepoint
seems like the much better long term strategy.  Even better if it allows
turning on individual points instead of all or nothing.

