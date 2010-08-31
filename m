Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0HaJfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:35:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55685 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753004Ab0HaJfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:35:36 -0400
Date: Tue, 31 Aug 2010 10:53:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, igor.stoppa@nokia.com, kai.svahn@nokia.com,
        mathias.nyman@nokia.com
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Message-ID: <20100831105337.7ba1dcaa@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830205011.GB28711@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
	<20100829184904.GC26209@core.coreip.homeip.net>
	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
	<20100830162855.GA17325@core.coreip.homeip.net>
	<d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com>
	<20100830172143.GA28275@core.coreip.homeip.net>
	<3fe11bc61e6a844b926ec4d32cec1474@secure211.sgcpanel.com>
	<20100830205011.GB28711@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > My hope is that we can make use of a well known and uniform
> > API for all input devices in a device, be it a keypad,
> > touchscreen, accelerometer, magnetometer, gyro, or whatever.
> > 
> 
> If only we could agree what input devices are...

Is that the right test for some of these devices.

Surely the question is "what devices can be meaningfully represented by
the input API". 

The device range is always going to be quite large and people want to use
the API because it means things just work. They can wire their home made
surfboard unit and tilt sensors up to the PC and tuxracer just goes. They
can wire pedals and a current meter to it and use it as the speed input in
bzflag to simulate bicycle tanks etc..

Alan
