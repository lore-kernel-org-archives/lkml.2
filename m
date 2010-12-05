Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0LETs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 14:48:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39879 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752458Ab0LETs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 14:48:58 -0500
Date: Sun, 5 Dec 2010 19:48:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Nikos Chantziaras <realnc@arcor.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Regression: sched: automated per session task groups
Message-ID: <20101205194811.3df4e8bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20101205171607.770a7810@schatten.dmk.lab>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	<AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	<idfrvp$l4o$1@dough.gmane.org>
	<20101205151220.0c532c94@pyx>
	<20101205171607.770a7810@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your rant about big bloated GNOME is... well just a rant. You will
> never be able to change it. You can just hope, that over time the
> evolutionary aspects of open source development will fix it. 

They already are - its dying slowly but surely.

> There is nothing wrong with trying to provide ease of use. Graphical
> interfaces that are well designed are easier to use. 

Interesting how you associate ease of use with being bloated and oversize.

> Most command-line people just can't cope with the unstable nature of
> interfaces in the graphical world.

Ah of course. How sweet, your response to a point about the arrogance of
certain desktop attitudes is to lecture, and make bogus pronouncements
about command-line people. You might want to put the shovel away instead.

> CLI's are mostly better from an ergonomic view (old people,
> heavy working hackers and other power users) because they provide
> a stable focus point.

And a bit of pop psychology to go with it. I assume you are trying to
talk about internalised and externalised models ?

> Most hackers probably don't realize this, but images/icons and other

No of course not we are all dim, thank you for using small words. I am
actually familiar with the real models here btw and there are a couple of
rather important basics you are missing

- Different people have different strengths in different areas - these
  don't specifically line up with the senses. There isn't vast amounts of
  evidence to support computing people are all strong in a particular
  area either. You'll see in studies that some of them prefer to
  diagram and flowchart, some write text, some have kinesthetic models
  (movement and flow). I don't doubt there are others who sense it in
  different ways.

- Visual and textual data communicate different things more effectively
  (as do sounds, smells, movements, ....) and are processed with
  different natural preferences by different people

- Oh and there is no evidence I've ever seen to suggest old people are
  more text oriented.

So any notion of CLI's or GUI's being better for [class of people] is
generally naïve. It depends what is being done, who is doing it and the
situation. 

If you really want to understand the trade-offs in a graphical world
watch some good CAD operators for an hour. They'll use the same tools in
very different ways - some very command line, some heavily
mouse/trackball, others graphical but with hotkeys, and they'll often
shift approach according to task.

> graphical interfaces are more similar to real life and are thus easier
> to use for 'unadapted' people.

If you wish to see an unadapted person you probably want to go look at
amazonian tribes. Bit different.

But then the GUI world is the world that put "logout" under "start" 8)
and thinks that "Insert OLE Object" is a good thing to put on a menu.

Alan
