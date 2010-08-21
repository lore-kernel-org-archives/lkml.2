Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0HURsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:48:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0HURr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:47:56 -0400
Date: Sat, 21 Aug 2010 13:47:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add --tui and --stdio to choose the UI
Message-ID: <20100821174754.GA10213@infradead.org>
References: <1282412712-3547-1-git-send-email-acme@infradead.org>
 <1282412712-3547-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282412712-3547-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 02:45:11PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Relying just on ~/.perfconfig or rebuilding the tool disabling support
> for the TUI is too cumbersome, so allow specifying which UI to use and
> make the command line switch override whatever is in ~/.perfconfig.

Much better than the current situation, thanks!

I still thinks commands like perf report should not be overloaded for
two different user interfaces, that is a

	perf report

should always be the line oriented interface, and the newt UI should be
something like

	perf treport

Btw, am I the only one that doesn't find the next interface too helpful?
In general the line oriented interface seem to present the information
much better, and in the cases where it gets too complicated the newt
interface doesn't really helper either.  A real gtk/qt interface with
a proper tree widget would seem like the more useful interface for that.

