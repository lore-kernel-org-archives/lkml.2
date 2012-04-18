Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2DRPaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2DRPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:30:07 -0400
Date: Wed, 18 Apr 2012 11:30:02 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418153002.GB17558@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418022705.GA23877@home.goodmis.org>
 <20120418031557.GA29828@redhat.com>
 <1334720611.28106.25.camel@gandalf.stny.rr.com>
 <20120418035004.GA31465@redhat.com>
 <1334721441.28106.28.camel@gandalf.stny.rr.com>
 <20120418040632.GB31465@redhat.com>
 <1334722164.28106.31.camel@gandalf.stny.rr.com>
 <20120418135815.GA10798@redhat.com>
 <1334760965.28106.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334760965.28106.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:56:05AM -0400, Steven Rostedt wrote:
 > On Wed, 2012-04-18 at 09:58 -0400, Dave Jones wrote:
 > 
 > >  > OK, function tracing is broken on your box. Could you send me your full
 > >  > config and I'll take a look at it tomorrow. Bed time for me now ;-)
 > > 
 > > http://fpaste.org/b8PN/raw/
 > 
 > Hmm, I had no problems with this config. But that wasn't on my Xeon. I'm
 > compiling for that box now.
 > 
 > Could you also paste your full dmesg.

Oh, I guess it's this..

"PEBS disabled due to CPU errata."

Crap. Never even noticed that before.

	Dave

