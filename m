Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2JCHAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:00:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50858 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2JCHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:00:08 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.46.74
Date: Tue, 2 Oct 2012 23:59:59 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Santos <daniel.santos@pobox.com>,
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
Message-ID: <20121003065959.GA4963@leaf>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-8-git-send-email-daniel.santos@pobox.com>
 <20120929002626.GD13907@jtriplet-mobl1>
 <50664308.6020601@att.net>
 <20120929005043.GD14293@jtriplet-mobl1>
 <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:49:03PM -0700, David Rientjes wrote:
> On Fri, 28 Sep 2012, Josh Triplett wrote:
> 
> > That issue doesn't relate to __flatten, though; it only relates to
> > __weak.  Since __flatten (and __compiletime_object_size) will work fine
> > on 4.1.0 and 4.1.1, don't exclude them just because the definition for
> > __weak elsewhere in the file excludes them.  That just makes it harder
> > for anyone who might want to work on the issue with __weak.
> > 
> 
> Nack to the patch since there are no users of it; there's no need to 
> define every possible gcc function attribute.  If anything actually needs 
> to use __attribute__((flatten)), then it can introduce it.

This patch series started out as part of another patch series by Daniel
Santos that makes use of __flatten; I think Daniel plans to have that
patch series depend on this one.  Thus, I think it makes sense to
introduce __flatten at this point.

- Josh Triplett
