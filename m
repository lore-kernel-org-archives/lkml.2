Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2I2AXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:23:39 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43001 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085Ab2I2AXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:23:37 -0400
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.46.74
Date: Fri, 28 Sep 2012 17:23:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
Subject: Re: [PATCH 5/10] compiler{,-gcc4}.h: Remove duplicate macros
Message-ID: <20120929002329.GB13907@jtriplet-mobl1>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-6-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348874411-28288-6-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 06:20:06PM -0500, Daniel Santos wrote:
> __linktime_error() does the same thing as __compiletime_error() and is
> only used in bug.h.  Since the macro defines a function attribute that
> will cause a failure at compile-time (not link-time), it makes more
> sense to keep __compiletime_error(), which is also neatly mated with
> __compiletime_warning().
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

Why not change bug.h in the same commit?  Or alternatively, why not
change it first?  Getting rid of __linktime_error *before* changing its
use in bug.h to __compiletime_error seems wrong.

- Josh Triplett
