Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab2EWPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab2EWPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:05:45 -0400
Date: Wed, 23 May 2012 11:05:40 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120523150540.GA2016@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <1334720611.28106.25.camel@gandalf.stny.rr.com>
 <20120418035004.GA31465@redhat.com>
 <1334721441.28106.28.camel@gandalf.stny.rr.com>
 <20120418040632.GB31465@redhat.com>
 <1334722164.28106.31.camel@gandalf.stny.rr.com>
 <20120418135815.GA10798@redhat.com>
 <1334760965.28106.39.camel@gandalf.stny.rr.com>
 <20120418153002.GB17558@redhat.com>
 <1334767425.28106.43.camel@gandalf.stny.rr.com>
 <1337783828.13348.158.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337783828.13348.158.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:37:08AM -0400, Steven Rostedt wrote:

 > > > Oh, I guess it's this..
 > > > 
 > > > "PEBS disabled due to CPU errata."
 > > > 
 > > > Crap. Never even noticed that before.
 > > 
 > > Yeah, but that shouldn't stop the function tracer from working.
 > 
 > Hi Dave,
 > 
 > Have we ever figured out why this wasn't working? Did it start working
 > on newer kernels?

I think that was where we left it.

But! Linus' current tree seems to have working tracing on that box.
Don't break it again! ;-)

	Dave

