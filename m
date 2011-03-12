Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1CLUyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:54:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54861 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754988Ab1CLUyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:54:49 -0500
Date: Sat, 12 Mar 2011 20:54:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Brigley <gbrigley@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to use gma500 framebuffer driver?
Message-ID: <20110312205459.333e6c33@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=mvLWd2eOgNc3L9swduoxJMhPO4_5C3Sfu5EwC@mail.gmail.com>
References: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
	<20110311193440.754b9636@lxorguk.ukuu.org.uk>
	<AANLkTi=mvLWd2eOgNc3L9swduoxJMhPO4_5C3Sfu5EwC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011 12:01:17 -0500
Greg Brigley <gbrigley@gmail.com> wrote:

> Thanks guys.  I went to retrieve a dmesg dump for Alan, and thought I
> should really do it without some other modules I had loaded, so the
> output would be less cluttered.  When I did that, the framebuffer
> worked!

It will probably fail if you have the vesa framebuffer driver enabled or
vga16fb.

> I'll figure out which other module was causing the trouble and report back.

That would be useful info.

> As for the mirrored display, is this something I might reasonably take
> on myself, having no experience with  video drivers?  If so, pointers
> for where to start looking would be great.

There are three things we need to do before we can do multi display
properly

- debug non panel outputs so the HDMI and other ports work on all systems
- an actual KMS X server
- a memory allocator (although in theory we don't need that if we stick
  to mirrored)

