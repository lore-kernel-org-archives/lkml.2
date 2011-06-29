Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1F2Sl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:41:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45860 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932095Ab1F2Sly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:41:54 -0400
Date: Wed, 29 Jun 2011 19:44:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 06/29] gma500: revamp frame buffer creation and handling
Message-ID: <20110629194421.090c9f1c@lxorguk.ukuu.org.uk>
In-Reply-To: <20110629093859.64f145ab@jbarnes-desktop>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
	<20110628220429.898.69509.stgit@bob.linux.org.uk>
	<20110629093859.64f145ab@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 09:38:59 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 28 Jun 2011 23:04:30 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > Restructure this to work the same way as the i915 frame buffer does. That
> > cleans up various chunks of code.
> > 
> > We can now set a mode in modetest but mode restore is a bit iffy
> 
> Note that modetest doesn't do the VT dance, so if you don't clean
> things up in your ->lastclose the right mode probably won't come back.

Yes I figured that and its a later patch. Really the core DRI code ought
to do this - it has the knowledge to sort the mess out (it knows how to
do it for sysrq-v)

Alan
