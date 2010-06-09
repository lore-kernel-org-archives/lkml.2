Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0FIMYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:24:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0FIMYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:24:02 -0400
Date: Wed, 9 Jun 2010 09:23:38 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100609122338.GA9471@ghostprotocols.net>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276065150.2046.1004.camel@twins>
 <20100609114753.GB5878@linux.vnet.ibm.com>
 <1276084414.2046.1335.camel@twins>
 <20100609120224.GA8359@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609120224.GA8359@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 09, 2010 at 09:02:24AM -0300, Arnaldo Carvalho de Melo escreveu:
> > On Wed, 2010-06-09 at 17:17 +0530, Srikar Dronamraju wrote:
> > > When ran gdb on the core, it showed me that it was dumping in
> > > /usr/lib64/libnewt.so.0.52. in newtScaleSet function.
> > > My newt lib was of version : newt-0.52.2-15

Can you please provide a backtrace? I think I know what the problem is,
but I'm not managing to reproduce it here.

> > > I am now able to workaround the problem by uninstalling newt-devel.

- Arnaldo
