Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1F1Wjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:39:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36306 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885Ab1F1Wj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:39:26 -0400
Date: Tue, 28 Jun 2011 23:41:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
Message-ID: <20110628234152.350eab07@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1106290003060.11049@pobox.suse.cz>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
	<20110616160642.6039.31781.stgit@localhost.localdomain>
	<20110628211859.GA23217@kroah.com>
	<20110628230245.4cec6958@lxorguk.ukuu.org.uk>
	<alpine.LNX.2.00.1106290003060.11049@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am still wondering how come that this is causing trouble to anyone 
> though -- is anyone really developing real code on top of linux-next 
> (which should be there to cross-check merge problems between subsystems 
> and test functionality) instead of particular subsystem tree?

I run -next on a regular basis. I'm actually doing a lot of Linux mid
development on it because I need bits going via various trees from x86 to
staging to input together.

I'm not btw saying your approach is wrong - in fact I imagine its the
only way to make it managable for some things but in the gma500 case at
least and I suspect much of staging it tends to cause merge problems. It
would be helpful if you route any gma500 bits via me because of the
amount of change in that subtree.

Alan
