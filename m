Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2JCOB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:01:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2JCOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:01:56 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=G3BEk8p8RQsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aoqRPjQY2hgA:10 a=D19gQVrFAAAA:8 a=rkHj0rLWfqlQ7V6cfNQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349272914.22822.169.camel@gandalf.local.home>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: David Rientjes <rientjes@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 03 Oct 2012 10:01:54 -0400
In-Reply-To: <506C1F8B.1070307@att.net>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
	 <1348874411-28288-8-git-send-email-daniel.santos@pobox.com>
	 <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net>
	 <20120929005043.GD14293@jtriplet-mobl1>
	 <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
	 <20121003065959.GA4963@leaf>
	 <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com>
	 <506C1F8B.1070307@att.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 06:20 -0500, Daniel Santos wrote:

> > Daniel, please introduce __flatten in the patch series that uses it, 
> > thanks.
> That isn't going to work. I split my patches out into three sets
> because, otherwise, the list of maintainers that must be CCed exceeds
> the allowable size of the LKML server and my messages get tagged as
> spam, causing untold confusion as messages reach maintainers, but not
> the LKML.  Please note from the summary of this patch set
> (https://lkml.org/lkml/2012/9/28/1136)

That's not a valid reason to not included it with the other patch
series.

> > This patch set is a dependency of the generic red-black tree patch set, which
> > I have now split up into three smaller sets.
> And the patch set this depends upon was submitted 9/28 as well
> (https://lkml.org/lkml/2012/9/28/1183) and the summary starts with this
> text:
> > This patch set depends upon the following:
> > * Cleanup & new features for compiler*.h and bug.h
> > * kernel-doc bug fixes (for generating docs)
> If I move this patch to the other patch set,
> scripts/get_maintainers.pl will give me a list longer than the LKML
> administrator will allow for recipients (1024 bytes max)

You don't need to use get_maintainers. It's more of a help tool to find
maintainers and not something that is mandatory. Not everyone that has
ever touched one of these files needs to be Cc'd.

Please move the patch to the patch series where it is used. Otherwise it
confuses reviewers as it did here.

-- Steve


