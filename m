Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0KKMwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:52:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0KKMwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:52:20 -0500
Date: Thu, 11 Nov 2010 07:51:57 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
Message-ID: <20101111125157.GA11194@infradead.org>
References: <20101110164413.GA5360@nowhere>
 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289466549-7602-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you explain again who this is supposed to be used?  It's missing
a lot of essential information about the page fault, but on the other
hand traces totally useless information like the task struct pointer.

What's your motivation for posting this given that you obviously
haven't actually tried to use it in practice?

Btw, this doesn't mean I'm against a page faul trace point - quite
contrary.  It just seems you're not actually pushing something that's
been tested in real life or is generally useful.

