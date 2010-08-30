Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0H3UWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:22:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40169 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753902Ab0H3UWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:22:35 -0400
Date: Mon, 30 Aug 2010 21:40:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hemanth V <hemanthv@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <igor.stoppa@nokia.com>,
        <kai.svahn@nokia.com>, <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Message-ID: <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
In-Reply-To: <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
	<20100829184904.GC26209@core.coreip.homeip.net>
	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 11:04:39 -0500
Felipe Balbi <me@felipebalbi.com> wrote:

> Hi Dmitry,
> 
> When we tried to push N900's accelerometer driver as an
> input device you commented you didn't want sensors such
> as accelerometers, magnetometers, proximity, etc on the
> input layer because "they are not user input", although
> I didn't fully agree with you, we had to modify the drivers
> and, I believe, one of them is sitting in staging under
> the industrial i/o subsystem.
> 
> Are you now accepting sensor drivers on the input layer ?
> that will make our life a lot easier but we need some
> definition to avoid having to re-work drivers when we
> want to push them to mainline.

I would certainly vote for them being input when they are sometimes used
that way - compasses for example do get used by applications (like
compass programs, some of the real cool visualisation tools and things
like live/game mixed gaming environments) and accelerometers are gaming
inputs. Proximity is also input for some stuff although usually of much
more interest to the GUI manager than the GUI apps.

ALS is more of a dual purpose thing -light levels are input features to
the GUI on PDAs, although on many embedded devices they are most
definitely part of the IIO subsystem.



