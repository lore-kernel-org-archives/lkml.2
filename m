Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1FHSu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:50:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:42427 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1FHSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:50:23 -0400
Date: Wed, 8 Jun 2011 14:50:16 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Mike Snitzer <snitzer@redhat.com>
Cc: John Kacur <jkacur@redhat.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
Message-ID: <20110608185016.GI30037@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Mike Snitzer <snitzer@redhat.com>, John Kacur <jkacur@redhat.com>,
	Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
	linux-kernel@vger.kernel.org
References: <4DEE1D96.6020208@profihost.ag>
 <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
 <4DEE2C70.8060301@profihost.ag>
 <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
 <4DEE9EDA.90001@profihost.ag>
 <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
 <BANLkTim3GuppJ4=VHa0BgNV1d4nQjWUcbg@mail.gmail.com>
 <20110608133833.GD30037@thunk.org>
 <BANLkTimMhZWhUN3w_9Qapsqcic2_VCP0sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimMhZWhUN3w_9Qapsqcic2_VCP0sg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 10:16:59AM -0400, Mike Snitzer wrote:
> 
> And what _exactly_ is Red Hat (not) doing?  Red Hat isn't going crazy
> backporting its upstream > 2.6.32 fixes to 2.6.32.y even when Red Hat
> doesn't consume 2.6.32.y?  *gasp*

Well, the original poster was expecting that (unspecified people)
would be doing this regularly (in fact he was complaining about how an
XFS bug fixed in RHEL wasn't fixed in 2.6.32.y).  I was explaining how
it wasn't happening, and it was perfectly acceptable for that to be
the case.

So I was actually *defending* Red Hat....

							- Ted
