Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1ECJi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:38:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47336 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752034Ab1ECJiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:38:54 -0400
Date: Tue, 3 May 2011 10:39:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic
 Systems TS-5xxx detection
Message-ID: <20110503103919.5b0daa5e@lxorguk.ukuu.org.uk>
In-Reply-To: <20110502215535.GA30373@kroah.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110429233230.GB24864@kroah.com>
	<1304368433-sup-4264@sfl>
	<20110502215535.GA30373@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I had a look at other drivers, and /sys/devices/platform/ts/ seems to be
> > a good place to hold those entries (one per options as you suggested).
> > Do you agree with that?
> 
> No, this is not a platform device, is it?  Only platform devices go
> there, and I really doubt you have many of them for this board.

It seems analogous to some of the laptop helpers so I don't think it is
that unreasonable to make the board config a platform device of its own -
we don't really have a general solution to the board as a device, so if
you look at equivalents on laptops and the like we have assorted platform
control interfaces that are platform devices.

Alan
