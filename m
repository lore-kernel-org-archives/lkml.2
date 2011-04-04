Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1DDU3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:29:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38452 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1DDU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:29:21 -0400
Date: Mon, 4 Apr 2011 15:29:09 -0500
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404202909.GA7873@peq.hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <20110404104119.78189678.akpm@linux-foundation.org>
 <20110404185119.GB4782@peq.hallyn.com>
 <20110404124222.fd5eb85b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404124222.fd5eb85b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Mon, 4 Apr 2011 13:51:20 -0500 "Serge E. Hallyn" <serge.hallyn@ubuntu.com> wrote:
> 
> > Quoting Andrew Morton (akpm@linux-foundation.org):
> > > On Mon, 4 Apr 2011 11:27:53 -0500 "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > > 
> > > > Andrew (Cc:d), did you see this thread go by, and it did it look
> > > > in any way more palatable to you?  Have you had any thoughts on
> > > > checkpoint/restart in the last few months?  Or did that horse quietly
> > > > die over winter?
> > > 
> > > argh, it was the victim of LIFO.
> > > 
> > > All I can say at this stage is that I'll be interested next time it
> > > comes past, sorry.
> > 
> > Thanks, that's good to know.
> > 
> > As you know, we started with a minimal patchset, then grew it over time
> > to answer the "but how will you (xyz) without uglifying the kernel".
> > Would you recommend we go back to keeping a separate minimal patchset,
> > or that we develop on the current, pretty feature-full version?  I'm not
> > convinced believe there will be bandwidth to keep two trees and do both
> > justice.
> 
> The minimal patchset is too minimal for Oren's use and the maximal
> patchset seems to have run aground on general kernel sentiment.  So I
> guess you either take the minimal patchset and make it less minimal or
> take the maximal patchset and make it less maximal, ending up with the
> same thing.  How's that for hand-waving useless obviousnesses :)

Perfect, thanks :)

> One obvious approach is to merge the minimal patchset then, over time,
> sneak more stuff into it so we end up with the maximal patchset which
> people didn't like.  Don't do that :)

Hoping that "which people didn't like" is purely conjecture.

Ok, I'll advocate for proceeding with the full patch-set as long as we
can.  Thanks, Andrew.

-serge
