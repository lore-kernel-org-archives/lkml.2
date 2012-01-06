Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406Ab2AFPaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:30:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030381Ab2AFP35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:29:57 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jLQ1fsfD-8uEmcvJr4oA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325863794.12696.71.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 06 Jan 2012 10:29:54 -0500
In-Reply-To: <1325851838.12696.70.camel@gandalf.stny.rr.com>
References: <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
	 <1325696759.12696.24.camel@gandalf.stny.rr.com>
	 <20120105091916.GA22598@elte.hu>
	 <1325764011.12696.38.camel@gandalf.stny.rr.com>
	 <1325765791.12696.41.camel@gandalf.stny.rr.com>
	 <1325825918.12696.64.camel@gandalf.stny.rr.com>
	 <20120106085104.GE14188@elte.hu>
	 <1325851838.12696.70.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 07:10 -0500, Steven Rostedt wrote:
> On Fri, 2012-01-06 at 09:51 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Not sure what else to do. Have you been able to trigger these 
> > > bugs without my patches? All the bugs I've been hitting after 
> > > merging my patches, I've been able to hit with tip/master as 
> > > well.
> > 
> > No, as i described to you the tree(s) without your patches all 
> > did 50+ series of bootups.
> > 
> 
> Is it only with this config that it fails? Is there another config that
> doesn't? Also is it only failing on one box, or can you reproduce the
> failure on different hardware? What version of fedora are you running?
> Could this be something that requires systemd?
> 

Also what compiler are you using? That may also make a difference.

-- Steve


