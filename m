Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab2INSH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:07:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2INSH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:07:27 -0400
Message-ID: <1347646039.7172.66.camel@twins>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise
 is not supported
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>
Date: Fri, 14 Sep 2012 20:07:19 +0200
In-Reply-To: <20120914180013.GA27766@ghostprotocols.net>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
	 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
	 <20120914054344.GB9043@gmail.com> <50531151.9020202@gmail.com>
	 <20120914113617.GA13299@gmail.com> <5053186E.6000302@gmail.com>
	 <20120914180013.GA27766@ghostprotocols.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 11:00 -0700, Arnaldo Carvalho de Melo wrote:
> > Understood and there have been suggestions on how to definitely state
> > what the kernel side did not like. I like Peter's last suggestion --
> > something along the lines of clearing attr on a failure except the
> > offending setting.
> 
> I think ws need to use a new bit 

Quite so, for all the reasons you list. But you like the general idea? I
wasn't sure I did, but it was the only thing I could come up with that
would sort of do what we need it to.

The fact that you destroy the user input is awkward, I don't think
there's another syscall that behaves in this fashion.
