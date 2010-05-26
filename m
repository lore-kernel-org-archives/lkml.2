Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0EZLDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:03:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0EZLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:03:43 -0400
Date: Wed, 26 May 2010 07:03:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526110320.GA27011@infradead.org>
References: <4BFCE849.7090804@cn.fujitsu.com> <20100526101617.GA14286@infradead.org> <20100526101837.GC5311@nowhere> <20100526102446.GA757@infradead.org> <20100526103222.GD5311@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526103222.GD5311@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:32:23PM +0200, Frederic Weisbecker wrote:
> But which debugfs code? Nothing related to $(DEBUGFS)/tracing right?

Exactly.  Blktrace creates it's own files under $(DEBUGFS)/block when
enabled through the old ioctls.

