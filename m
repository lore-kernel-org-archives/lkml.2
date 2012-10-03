Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2JCPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:38:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008Ab2JCPiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:38:19 -0400
Message-ID: <1349278697.2112.1.camel@joe-AO722>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 03 Oct 2012 08:38:17 -0700
In-Reply-To: <1349277241.22822.176.camel@gandalf.local.home>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
	 <1348874411-28288-8-git-send-email-daniel.santos@pobox.com>
	 <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net>
	 <20120929005043.GD14293@jtriplet-mobl1>
	 <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
	 <20121003065959.GA4963@leaf>
	 <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com>
	 <506C1F8B.1070307@att.net> <1349272914.22822.169.camel@gandalf.local.home>
	 <506C4FD0.4040307@att.net> <1349277241.22822.176.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 11:14 -0400, Steven Rostedt wrote:
> I first check
> the MAINTAINERS file. If the subsystem I'm working on exists there, I
> only email those that are listed there, including any mailing lists that
> are mentioned (as well as LKML). If it's not listed, I then do a git log
> and see who does the most sign offs to changes there, and to what kind
> of changes. I usually ignore the trivial stuff.

Funny because that's what the script does too.


