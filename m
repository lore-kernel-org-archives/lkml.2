Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab1IIQZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:25:33 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45735 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1IIQZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:25:32 -0400
Date: Fri, 9 Sep 2011 12:25:24 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Sandy Harris <sandyinchina@gmail.com>, Neil Horman <nhorman@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110909162524.GA3818@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
	Sandy Harris <sandyinchina@gmail.com>,
	Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <201109080911.12921.sgrubb@redhat.com>
 <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
 <201109090904.18321.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090904.18321.sgrubb@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 09:04:17AM -0400, Steve Grubb wrote: But what
> I was trying to say is that we can't depend on these supplemental
> hardware devices like TPM because we don't have access to the
> proprietary technical details that would be necessary to supplement
> the analysis. And when it comes to TPM chips, I bet each chip has
> different details and entropy sources and entropy estimations and
> rates. Those details we can't get at, so we can't solve the problem
> by including that hardware. That is the point I was trying to
> make. :)

Let's be clear that _we_ which Steve is referring to is Red Hat's
attempt to get a BSI certification so they can make $$$.  It has
nothing to do with security, except indirectly, and in my opinion,
breaking application by causing network daemons to suddenly lock up
randomly just so that Red Hat can make more $$$ is not a good reason
to push a incompatible behavioural change into /dev/random.

   	  	       		   	       - Ted
