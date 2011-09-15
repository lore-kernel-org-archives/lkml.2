Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab1IOT2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:28:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37922 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934209Ab1IOT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:28:48 -0400
Date: Thu, 15 Sep 2011 20:28:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Alex Deucher <alexdeucher@gmail.com>, Keith Packard <keithp@keithp.com>,
        linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, "Clark, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110915202800.6320826a@lxorguk.ukuu.org.uk>
In-Reply-To: <4E724F93.1050203@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<4E724F93.1050203@gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As you have DRM now and as I'm not interested in wayland I won't discuss this,
> but I guess it might be a good start for Geert's question what would be needed
> to use it on dumb framebuffers.

GMA500 is basically a 2D or dumb frame buffer setup but with a lot of
rather complicated output and memory management required due to the
hardware. With the latest changes to GEM (private objects) it's basically
trivial to use the frame buffer management interfaces.

> Yes, if you limit DRM to the functionality of the fb API I guess you could reach
> the same stability level. But where can I do this? Where is a option to forbid
> all acceleration or at least limit to the acceleration that can be done without
> any risk?

A driver can provide such module options as it wants.

> That's a really difficult question. Determining the users is difficult and there
> are people that use their hardware very long, for example we are about to get a
> new driver for i740. For the framebuffer infrastructure I guess you have to at
> least wait for my death.

I doubt it'll be that long - but you are right it will take time and
there isn't really any need to push or force it. These things take care
of themselves and in time nobody will care about the old fb stuff, either
because DRM covers it all or equally possibly because it doesn't support
3D holographic projection 8)

Alan
