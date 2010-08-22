Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0HVOLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 10:11:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0HVOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 10:11:37 -0400
Date: Sun, 22 Aug 2010 11:11:23 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add --tui and --stdio to choose the UI
Message-ID: <20100822141123.GE19201@ghostprotocols.net>
References: <1282412712-3547-1-git-send-email-acme@infradead.org>
 <1282412712-3547-2-git-send-email-acme@infradead.org>
 <20100821174754.GA10213@infradead.org>
 <20100821182658.GH2973@ghostprotocols.net>
 <20100822082003.GB7365@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100822082003.GB7365@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 22, 2010 at 04:20:03AM -0400, Christoph Hellwig escreveu:
> On Sat, Aug 21, 2010 at 03:26:58PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Btw, am I the only one that doesn't find the next interface too helpful?
> > > In general the line oriented interface seem to present the information
> > > much better, and in the cases where it gets too complicated the newt

> > Much better how, exactly?

>  - it uses the space available in a terminal window much more
>    efficiently.  Output starts in row 0, column 0 and expands all the
>    way that's needed.
>  - it incluses a descruption of what the columns of output mean
>  - it provides percentages for the individual callchains parts after
>    branching out
>  - in graph/fractal modes there are lines that show how the parts
>    are connected, making it possible to read the output, unlinke
>    the TUI mode where the "expanind" nodes are very hard to follow.
>  - just running perf reports gets an overview of all callchains instead
>    of having to expand dozens of things
>  - the colour scheme is the normal shell one (light gray on black for
>    me) instead of one hurting the eyes

All good points, will work on them, thanks for pointing them out!
 
> 
> > > interface doesn't really helper either.  A real gtk/qt interface with
> > > a proper tree widget would seem like the more useful interface for that.
> > 
> > What would a gtk/qt interface buy us that is not present on the TUI
> > right now?
> 
> Generally for tree/graph like data structures a real X GUI provides much
> nicer rendering.  It'll allow to render the connected lines just as in
> the line oriented interface, but in a nicer way using real thin lines

Cool, connected lines is something that indeed has to happen, just like
mutt in threaded mode, will work on that.

> in a tree widget.  It'll also genereally allow better text placement
> in the window compared to the single centered window in the newt
> interface.   Also the GUI programs follow the common color scheme of the
> rest of the desktop instead of hurting your eye.  In addition to that

Lets stop hurting eyes!

> scrollbars (horizontal / vertical) are a lot more intuitive in a typical
> X GUI than in newt.

Ok, thanks for the detailed description of the problems.

- Arnaldo
