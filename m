Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2GPVEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:04:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36207 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2GPVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:04:05 -0400
Date: Mon, 16 Jul 2012 22:07:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm gma500 fixes
Message-ID: <20120716220743.61cf21d4@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFypB-Tn+6WQCZauU16QuVGBfr-TjDZrxuxL5SU_bbJTVw@mail.gmail.com>
References: <alpine.DEB.2.00.1207162041400.28607@skynet.skynet.ie>
	<CA+55aFypB-Tn+6WQCZauU16QuVGBfr-TjDZrxuxL5SU_bbJTVw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012 13:44:32 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 16, 2012 at 12:42 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > Sorry been travelling and a bit neglectful of some of Alan's
> > patches,
> 
> I actually took the three Alan sent me already, exactly because they
> seemed harmless and I didn't know your schedule.
> 
> Your pull has a "gma500: Fix frequency detection" patch that I haven't
> seen though, which makes me wonder if Alan wants that one too. He only
> sent me a series of the three other patches..
> 
> Alan?

The frequency detect bug isn't a regression, indeed its not clear it's a
path ever taken.

Alan
