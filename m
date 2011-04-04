Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1DDXnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:43:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56640 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1DDXn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:43:29 -0400
Date: Mon, 4 Apr 2011 16:43:23 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404234323.GC27628@count0.beaverton.ibm.com>
References: <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <20110404104119.78189678.akpm@linux-foundation.org>
 <20110404185119.GB4782@peq.hallyn.com>
 <20110404124222.fd5eb85b.akpm@linux-foundation.org>
 <20110404215511.GA27628@count0.beaverton.ibm.com>
 <31800.1301959010@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31800.1301959010@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 07:16:50PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 04 Apr 2011 14:55:11 PDT, Matt Helsley said:
> 
> > Now we're back with a new minimal patch set. You're asking us to do the same
> > thing and expect different results -- stack more patches on top and expect to
> > get it reviewed. OK, but what reason do we have to believe this time will be
> > any different?
> 
> Has the terrain changed any since last time? In particular, ISTR a bunch of
> activity in namespace support since last time - does that change what your
> patch set needs to do?

Good question.

Unfortunately it doesn't reduce what our patch set needs to do at this
point. The primary namespace changes that happened about 10+ kernel
versions ago (circa 2.6.28) are essential for containers and reliable
checkpoint/restart. Since then namespace improvements have nothing or very
little to do with enabling checkpoint/restart -- it's all for containers.

Cheers,
	-Matt Helsley
