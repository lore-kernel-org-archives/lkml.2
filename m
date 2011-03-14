Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1CNWUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:20:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37074 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1CNWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=sm7UUGTKlcMIO7MQ1XRgut+V1fc/wbvIdegfFy91nB/KE/jBLsJHZ4hr4ZEctYpLqV
         xZDOvytt9lZEt69UNK1Pzp9nfFwl2ydVMb19vuDiPqsigLTI9s2HJOP0YQqXc8PNNiDL
         O9fl52ZfX82YWSAxjmDhefav3ns/sDRT3Vzfg=
Date: Mon, 14 Mar 2011 19:19:54 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110314221954.GE2388@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314215603.GD2388@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 06:56:03PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Mar 14, 2011 at 10:20:53PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> > > But I could think of this as a way to express filters:

> > > $ perf record -e instructions@irq:irq:irq_handler_entry(irq=eth0)..irq:irq_handler_exit(\1) \
> > > 	      -e instructions \
> > > 	netperf

> > > looks quite natural for someone used to git and sed, i.e. developers :)

> > Yeah indeed, I like filters defined in parenthesis after the event!
> 
> :-)

Also it would be good to look at 68baa43 and think about ways to share
code/syntax in static and dynamic probes...

- Arnaldo
