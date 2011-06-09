Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab1FILxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:53:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44402 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754443Ab1FILx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:53:27 -0400
Date: Thu, 9 Jun 2011 12:55:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@redhat.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
Message-ID: <20110609125521.63e6df68@lxorguk.ukuu.org.uk>
In-Reply-To: <1307615814.5963.2.camel@t60prh>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<20110608101515.9478.67943.stgit@localhost.localdomain>
	<BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	<20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
	<1307615814.5963.2.camel@t60prh>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Though if psb wants to be different to other drm drivers it can lead the
> way, though it'll be a total nightmare for all the people who follow
> documentation on how to debug drm drivers using drm.debug=1,2,4,8. for
> various code paths.

Actually it seems to work out nicely because you can debug DRM core
goings on and driver goings on separately. Also the driver ones can be
turned on/off on their own at runtime which is a godsend.

As you can imagine I've been testing the debugging a fair bit !

Alan
