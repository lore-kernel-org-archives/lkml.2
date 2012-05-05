Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2EEPjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:39:49 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:1520 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754034Ab2EEPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:39:48 -0400
Date: Sat, 5 May 2012 11:39:44 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Maarten Maathuis <madman2003@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120505153944.GA17057@elliptictech.com>
References: <1335322574.1821.8.camel@nisroch>
 <1335504021.5311.0.camel@nisroch>
 <20120428003928.GA16805@elliptictech.com>
 <CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
 <20120428153350.GA19561@elliptictech.com>
 <20120429223744.GA19382@core.coreip.homeip.net>
 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
 <20120501132352.GA28696@elliptictech.com>
 <20120502012029.GA24097@elliptictech.com>
 <CAPM=9tynyGoV6ppRZe+y5WGUbQRSPc+ih9RL2HZQu951AoZiog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tynyGoV6ppRZe+y5WGUbQRSPc+ih9RL2HZQu951AoZiog@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-04 10:20 +0100, Dave Airlie wrote:
> >>
> >> FWIW, for me EDID failure on new kernels is 100% reproducible, and there
> >> are no such checksum errors in the log.  It's just missing.
> >>
> >> > Just a crazy thought, but didn't we change some timings related to
> >> > EDID retrieval? To make it faster.
> >>
> >> OK, this time bisecting started off relatively smoothly (doing the same
> >> "backwards" bisect on the branch-o-reverts as last time), but then my
> >> disk died halfway through...
> > [...]
> >
> > OK, system is back online and I finished the bisection.  The commit that
> > broke it for me is the following, and reverting it on top of 3.3.4 + the
> > "make VGA work at all" patch fixes this particular issue for me.
> >
> Can you test with the attached patch? its a revert mostly of Ben's patch, and
> he says with the i2c core change stuff is working for him again.

Yup, this one seems to work on top of Linus' master.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

