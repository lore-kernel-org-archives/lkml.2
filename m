Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab2DREHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2DREHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:07:05 -0400
Date: Wed, 18 Apr 2012 00:07:02 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418040702.GC31465@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418022705.GA23877@home.goodmis.org>
 <20120418031557.GA29828@redhat.com>
 <1334720611.28106.25.camel@gandalf.stny.rr.com>
 <20120418035004.GA31465@redhat.com>
 <1334721441.28106.28.camel@gandalf.stny.rr.com>
 <1334721644.28106.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334721644.28106.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 12:00:44AM -0400, Steven Rostedt wrote:
 > On Tue, 2012-04-17 at 23:57 -0400, Steven Rostedt wrote:
 > 
 > > Also, have you tested to see if function tracing works?
 > > 
 > > # cd /sys/kernel/debug/tracing
 > > # echo function > current_tracer
 > > # cat trace
 > 
 > Also make sure that the max is zero:
 > 
 > # cat stack_max_size
 > # echo 0 > stack_max_size

Yep, it is zero.

	Dave

