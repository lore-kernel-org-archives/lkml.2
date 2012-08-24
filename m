Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2HXQbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:31:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60292 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab2HXQbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:31:42 -0400
Date: Fri, 24 Aug 2012 17:36:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: wbrana <wbrana@gmail.com>
Cc: Chen <hi3766691@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
Message-ID: <20120824173626.0194625c@pyramind.ukuu.org.uk>
In-Reply-To: <CAJ7jCmme5VNO9aX0SVtmVGUdJj4QODRE4+oPxBE62yCRKcVK6w@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
	<201208231951.28606.linux@rainbow-software.org>
	<CAJ7jCmnwXNXmoxT6sdOc-8znsUnnW+Rq8ioJ_8B8KnT0K2uc=A@mail.gmail.com>
	<1345812057.28613.20.camel@thorin>
	<CAJ7jCm=bZoHS0-qiiJnUjZb3gP6ibo1xbLsmaUJr2rL4pAU8Eg@mail.gmail.com>
	<1345823281.28613.34.camel@thorin>
	<CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com>
	<CANQmPXgefyCJuzFiAugp6OW2+HtjABSWuQqG33gAU_XgQ1V_2A@mail.gmail.com>
	<CAJ7jCmme5VNO9aX0SVtmVGUdJj4QODRE4+oPxBE62yCRKcVK6w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> almost all x86-32 boxes will be trash in 2017, remaining boxes will
> use long term tree

People will still be manufacturing 32bit x86 processors in 2017 I'm quite
sure. You appear entirely out of touch. There are already serious
discussions going on about things like the kernel modifications needed to
make 32bit systems run past 2038. 

Besides which what Linux supports is defined by what peope chose to
contribute code for. We support 32bit 680x0 machines that have been
obsolete for nigh on 20 years because someone chooses to support them.

For that matter if someone comes along with DEC-10 port and it works as
was clean without messing up the core I'm sure we'd add that too!

Alan


