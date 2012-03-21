Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2CUEgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:36:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44298 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752178Ab2CUEgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:36:00 -0400
Message-ID: <1332304558.29403.17.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Mar 2012 21:35:58 -0700
In-Reply-To: <20120321042805.GB1979@leaf>
References: <20120320210644.GA2493@leaf>
	 <1332293056.27711.12.camel@joe2Laptop> <20120321042805.GB1979@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 21:28 -0700, Josh Triplett wrote:
> On Tue, Mar 20, 2012 at 06:24:16PM -0700, Joe Perches wrote:
> > I don't recall seeing your patch before, but I submitted
> > a similar one that I believe Andrew has in his tree.
> You reviewed my patch at the time and provided feedback, and I'd
> produced a revised version based on that feedback.

duh.

I heard short term memory fades as you get age,
but I might not remember that in awhile.

> The heuristics in the patch I submitted almost completely eliminate
> false positives, which makes my patch suitable for use without --strict.

Yup, this patch is better than the one I submitted.

One improvement might be to check for a line continuation \
on $prevline and still produce a warning in that case.

cheers, Joe

