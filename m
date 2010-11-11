Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0KKNRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:17:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0KKNRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:17:03 -0500
Date: Thu, 11 Nov 2010 14:15:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
Message-ID: <20101111131545.GA10022@jolsa.brq.redhat.com>
References: <20101110164413.GA5360@nowhere>
 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
 <20101111125157.GA11194@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111125157.GA11194@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:51:57AM -0500, Christoph Hellwig wrote:
> Can you explain again who this is supposed to be used?  It's missing
> a lot of essential information about the page fault, but on the other
> hand traces totally useless information like the task struct pointer.
> 
> What's your motivation for posting this given that you obviously
> haven't actually tried to use it in practice?
yep, kind of doing this for Larry... hoping he'd fill in to the
discussion ;)

> 
> Btw, this doesn't mean I'm against a page faul trace point - quite
> contrary.  It just seems you're not actually pushing something that's
> been tested in real life or is generally useful.
What would be your idea of the page fault tracepoint?

thanks,
jirka
