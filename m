Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1IORSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:18:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33659 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756445Ab1IORSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:18:53 -0400
Date: Thu, 15 Sep 2011 18:18:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Keith Packard <keithp@keithp.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark\, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110915181802.69ef0d56@lxorguk.ukuu.org.uk>
In-Reply-To: <4E72320B.6020000@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> is and we could use it. Such attitude is not helpful and as I don't see any
> serious intention of the DRM guys to cooperate I think those subsystems are more
> likely to diverge. At least I'll never accept any change to the fb
> infrastructure that requires DRM.

There are aspects of the fb code that want changing for DRM (and indeed
modern hardware) but which won't break for other stuff. Given the move to
using main memory for video and the need for the OS to do buffer
management for framebuffers I suspect a move to DRM is pretty much
inevitable, along with having to fix the fb layer to cope with
discontiguous framebuffers.

Alan
