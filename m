Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1FHJBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:01:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40453 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752429Ab1FHJBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:01:45 -0400
Date: Wed, 8 Jun 2011 10:03:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
Message-ID: <20110608100338.66a98328@lxorguk.ukuu.org.uk>
In-Reply-To: <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
References: <4DEE1D96.6020208@profihost.ag>
	<6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
	<4DEE2C70.8060301@profihost.ag>
	<alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
	<4DEE9EDA.90001@profihost.ag>
	<C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That was what i thoght. So a bug like this should get fixed right? Otherwise this makes no sense. Sadly Redhat has ported the fix back in his RHEL 6 2.6.32 kernel but they haven't send the patch to stable / vanilla team.

It's often not that simple. As vendor trees diverge you may find it's not
a case of 'sending patch X upstream' because the patches you need may
well depend upon other things in the vendor tree not all of which will be
in the 'stable' tree. So it's a base at best.

> Not all distributions will participate in the maintenance stable tree.  Red Hat for example is probably worried about people  (specifically, Oracle) taking their kernel expertise "for free" and bidding it against them.

Judging from the commit log that isn't the case.

Besides which I hear a rumour that oracle employees have learned how to
download files from other websites and look at the content so it won't
make any odds 8)

Alan
