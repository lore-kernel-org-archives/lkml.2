Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0HUOoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:44:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0HUOox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:44:53 -0400
Date: Sat, 21 Aug 2010 10:44:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100821144452.GB31202@infradead.org>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
 <20100820091645.GA20138@infradead.org>
 <20100820191230.GD14788@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820191230.GD14788@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:12:30PM -0300, Arnaldo Carvalho de Melo wrote:
> In fact I never run 'perf report' specifying '-g', have you tried it
> that way?

Yes, same issue.

> It should work on the stdio mode, IIRC Fr?d?ric told me he found and fixed the
> problem there, right?

With the patch some modes work, but not all.

And I'm getting really eager to get separate commands for TUI with line
mode perf report.  Having to recompile the damn thing all the time or
tweak config files (which is even worse) is getting highly annoying.

