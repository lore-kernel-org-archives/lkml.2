Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2CZPOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:14:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34293 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab2CZPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:14:37 -0400
Date: Mon, 26 Mar 2012 17:14:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120326151432.GA8527@gmail.com>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
 <20120324074412.GE20145@gmail.com>
 <20120326122632.GC32090@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326122632.GC32090@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Sat, Mar 24, 2012 at 08:44:12AM +0100, Ingo Molnar wrote:
> > Could this also be accessible via 'make tools' in the toplevel 
> > Makefile?
> > 
> > I'd love to be able to type:
> > 
> >   make -j tools perf install
> 
> Well,
> 
> you could do
> 
> $ make -j -C tools perf

Arguably I could also type:

  cd tools/perf; make -j install

:-)

So I just wanted to bring this up, that integrating it into the 
top level Makefile might make sense. Or not.

Thanks,

	Ingo
