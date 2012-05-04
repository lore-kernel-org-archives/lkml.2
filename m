Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2EDPPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:15:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2EDPPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:15:24 -0400
Subject: Re: Linux 3.4-rc4
From: Jean Delvare <jdelvare@suse.de>
To: skeggsb@gmail.com
Cc: Bowler <nbowler@elliptictech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Nick@freedesktop.org,
        Martin Peres <martin.peres@labri.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1336108085.1803.10.camel@nisroch>
References: <20120422164023.GA32342@elliptictech.com>
	 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
	 <CAKPcRGpxb6b-z3t8Lv6YU9+ttgeXTRtGyvCFb=RSDQOJMTqEjQ@mail.gmail.com>
	 <201205020954.13273.jdelvare@suse.de> <1335958306.1898.7.camel@nisroch>
	 <1336108085.1803.10.camel@nisroch>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 04 May 2012 16:12:50 +0200
Message-ID: <1336140770.22023.4.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Testing new e-mail client at work, please forgive and bear with me if
anything goes wrong.)

On ven., 2012-05-04 at 15:08 +1000, Ben Skeggs wrote:
> On Wed, 2012-05-02 at 21:31 +1000, Ben Skeggs wrote:
> > On Wed, 2012-05-02 at 09:54 +0200, Jean Delvare wrote:
> > > BTW, Ben, there were two interesting fixes to i2c-algo-bit meanwhile,
> > > you may want to try using it again.
> > Hey Jean,
> > 
> > Thanks!  I did notice this, and your email, a while back.  I just
> > haven't yet had the time to see how the NVS300 goes now.  I do
> > definitely plan on taking a peek however.
> I had the NVS300 in today for some other work so I took the chance to
> see how it went now.  The good news is, i2c-algo-bit works with it now
> \o/
> 
> I've got a patch ready removing our custom implementation, and it'll be
> in nouveau git later today.

This is good news. Maybe it will even fix Maarten's issue.

> Thanks a heap for the heads up, and for fixing my issues with
> i2c-algo-bit!

All the praise should go to Ville Syrjälä, he spotted the 10 year old
bug and fixed it. Great timing too :)

-- 
Jean Delvare
Suse L3


