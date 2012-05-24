Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2EXVP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab2EXVPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:15:25 -0400
Date: Thu, 24 May 2012 17:15:20 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kbuild@vger.kernel.org
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524211520.GA2800@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, linux-kbuild@vger.kernel.org
References: <1337876398.13348.178.camel@gandalf.stny.rr.com>
 <20120524172223.GA10689@redhat.com>
 <1337880914.13348.189.camel@gandalf.stny.rr.com>
 <20120524184728.GA13201@redhat.com>
 <1337885672.13348.194.camel@gandalf.stny.rr.com>
 <20120524191147.GA13936@redhat.com>
 <1337887495.13348.195.camel@gandalf.stny.rr.com>
 <20120524200541.GA6552@redhat.com>
 <1337890690.13348.199.camel@gandalf.stny.rr.com>
 <1337891586.13348.202.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337891586.13348.202.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 04:33:06PM -0400, Steven Rostedt wrote:

 > I'm kicking off the ktest that initially caused this issue hoping that
 > it reproduces the bad tree again.
 > 
 > BTW, did you happen to upgrade gcc or anything? The ktest I run does
 > test against different gcc's and I don't think I had it do a make clean
 > between the switch. That may be the cause of this problem too :-?

No gcc updates. It's a Fedora 17 box, so there's been hardly any updates this
last week or so as things have been frozen leading into the release.

	Dave

