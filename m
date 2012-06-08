Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2FHQFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:05:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2FHQFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:05:01 -0400
Date: Fri, 8 Jun 2012 12:48:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120608154814.GA21250@infradead.org>
References: <20120607202355.GQ27374@one.firstfloor.org>
 <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com>
 <20120607205836.GT27374@one.firstfloor.org>
 <20120607212759.GD30641@infradead.org>
 <20120608031009.GV27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608031009.GV27374@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 08, 2012 at 05:10:09AM +0200, Andi Kleen escreveu:
> > Are you sure the old one works? Perhaps it silently falls back to
> > cpu-clock?
 
> Yes i'm sure. I was actually debugging some kernel pebs code,
> and had a heavily instrumented pebs code path and was first trying
> to figure out what went wrong in the kernel, until I realized 
> that the userland was broken.
> 
> Does :p work for anyone else?

It seems to work for Linus on Ivy Bridge with what is on tip/perf/urgent
 
> BTW I hope the perf userland becomes more stable again. Recently I've had
> far more trouble with the user binary than the kernel driver, which
> is unusal.

Well, as a feedback your post is very much appreciated, we'll try to do
better.

What areas do you feel are more troubling? Anything you reported that
still hasn't been fixed?

Probably we should stop working on features and just process patches and
work on a suite of autotest scripts, something we've been discussing but
not working that much at.

- Arnaldo
