Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2DNT7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:59:43 -0400
Received: from 1wt.eu ([62.212.114.60]:65182 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab2DNT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:59:13 -0400
Date: Sat, 14 Apr 2012 21:58:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414195834.GI19802@1wt.eu>
References: <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413154216.476a02ac@stein> <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com> <20120414094137.54a7f213@stein> <CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com> <20120414155733.GF19802@1wt.eu> <CAMP44s0omtoT=4zN=sOQYGLwfWGiw4w4iAj+OS+gGOsNMatq9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0omtoT=4zN=sOQYGLwfWGiw4w4iAj+OS+gGOsNMatq9g@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 10:33:59PM +0300, Felipe Contreras wrote:
> >> Again, what makes a released patch undroppable?
> >
> > Being applied, in other words, having a commit ID in the branch.
> 
> Seriously? That's your reason?
> 
> Hey, thousands of users out there; the reason why we pushed a patch
> that is known to be broken in v3.3.x is because it already has a
> commit ID.

I think you have a real problem with logics in general as it's not the
first time you're reverting cause and consequence in people's arguments.

I'm basically saying that we don't revert patches any other way than
by backporting the revert and you're saying that every patch has to
be backported. Come on, this discussion makes no sense at all. You're
wasting everyone's time for nothing, just because you want to be right
even after everyone explained you the same thing. You got me bored.

Willy

