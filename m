Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1FIMCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:02:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45525 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972Ab1FIMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:02:37 -0400
Date: Thu, 9 Jun 2011 13:04:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
Message-ID: <20110609130431.0c29218a@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<20110608101515.9478.67943.stgit@localhost.localdomain>
	<BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	<20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
	<1307615814.5963.2.camel@t60prh>
	<BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, my concern was about drm.debug and use of all the DRM portability stuff
> (like using DRM_IRQ_HANDLED instead of IRQ_HANDLED, etc...)
> 
> The portability might not be important at this point but I just wanted to raise
> the question so I know what is right / wrong.

The gma500 driver uses a lot of direct Linux services rather than
disappearing into the weird world of drm_mm and the like so any
portability is going to be a bit of an illusion at best.

If someone ports it to another GPL licensed OS then I may have to
reconsider a bit, we shall see.
 
> Alan, I've been working on the output code but think I've reached a dead end.
> I'm up to 20000 lines of changes and it's just a big mess. I'm gonna go for
> slowly fixing up the current code instead. I also got my hands on a laptop
> with a gma500 so I can test that my changes doesn't break LVDS. Stay tuned.

Will do. Got another chunk of patches to fire at Greg shortly and I've
now beaten pretty much all of it into passing CodingStyle so hopefully
any noise will settle down at that point.

Still not ready to leave staging, passing CodingStyle and being clean are
not quite the same thing in this case !
