Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1KXVV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:21:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44843 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab1KXVV5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:21:57 -0500
Date: Thu, 24 Nov 2011 21:23:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20111124212318.0ba3beb8@lxorguk.ukuu.org.uk>
In-Reply-To: <20111124162014.GA2750@Boggieman>
References: <20111121182910.GA2856@Boggieman>
	<20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
	<CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
	<20111124162014.GA2750@Boggieman>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 17:20:14 +0100
Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:

> It works for me, however if external display is connected it defaults to 1024x768 (as patrik
> pointed out). The internal screen gets mirrored and therefore looses about 600x768 pixels (which look like
> memory garbage). 

That sounds like a bug in the internal screen set up. In mirrorred mode
picking 1024x768 is reasonable enough but it ought to be centreing and/or
scaling the display.

> > Worth pointing out is that DDC for external displays isn't working until my
> > fixes for SDVO gets in there. Manually setting a mode works fine. Otherwise
> > you'll default to 1280x1024 (or was it 1024x768?).

> Im not able to set any resolution at all for the external screen, its always 1024x768.
> I cannot be 100% sure that its not my external screen not accepting the 1600x768 resolution
> and they therefor find the largest compatible resolution.

See above 8)

> > > - 2D hardware acceleration except console scrolling (as it seems to be
> > >  too slow to be useful). I may add some 2D bits later where they do help
> > >  (eg back to front blitting may be worth it just about)
> > > - 3D engine (no public documentation)
> 
> Can any parts of the i915 be used?

Alas not

Alan
