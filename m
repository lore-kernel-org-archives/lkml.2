Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0HUOq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:46:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0HUOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:46:27 -0400
Date: Sat, 21 Aug 2010 10:46:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100821144625.GA19711@infradead.org>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
 <20100820091645.GA20138@infradead.org>
 <20100821024713.GD7959@nowhere>
 <20100821144239.GA31202@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821144239.GA31202@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 10:42:39AM -0400, Christoph Hellwig wrote:
> It does seem to fix the bug for some cases but not all.  Default perf
> report in TUI and the normal command line seem to get it right.  perf
> report -g flat still shows the old problem.  perf report -g flat,0.0
> shows callgraphs, but just as before they just show the 0.<n>
> percentages.

-g graph also shows the same issue of not beeing able to expand the
python line.  It seems like only the fractal case was fixed by that
patch.

