Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2CUGFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:05:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52312 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2CUGFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:05:53 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.46.74
Date: Tue, 20 Mar 2012 23:05:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120321060544.GA2831@leaf>
References: <20120320210644.GA2493@leaf>
 <1332293056.27711.12.camel@joe2Laptop>
 <20120321042805.GB1979@leaf>
 <1332304558.29403.17.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332304558.29403.17.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 09:35:58PM -0700, Joe Perches wrote:
> On Tue, 2012-03-20 at 21:28 -0700, Josh Triplett wrote:
> > The heuristics in the patch I submitted almost completely eliminate
> > false positives, which makes my patch suitable for use without --strict.
> 
> Yup, this patch is better than the one I submitted.

OK.  Andrew, could you substitute my patch for Joe's in your tree?

> One improvement might be to check for a line continuation \
> on $prevline and still produce a warning in that case.

I'd suggest doing that one as a separate check, "unnecessary line
continuation", which should flag any use of a line continuation other
than with a preprocessor directive.  I don't think combining that with
the wrapped-string check makes sense.

- Josh Triplett
