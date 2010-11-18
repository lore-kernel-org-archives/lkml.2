Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0KRJyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:54:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34545 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755084Ab0KRJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:54:50 -0500
Date: Thu, 18 Nov 2010 09:53:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Blanchard <anton@au1.ibm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101118095300.3ea74268@lxorguk.ukuu.org.uk>
In-Reply-To: <20101117162922.0f874a8e@kryten>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
	<AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
	<20101117162922.0f874a8e@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problems found in HPC often turn into more general problems down
> the track. I think back to the heated discussions we had around SMP back
> in the early 2000s when we had 32 core POWER4s and SGI had similar sized
> machines. Now a 24 core machine fits in 1U and can be purchased for
> under $5k. NUMA support, CPU affinity and multi queue scheduling are
> other areas that initially had a very small user base but have since
> become important features for many users.

	I'd prefer the trees to be separate for testing purposes: it 
	doens't	make much sense to have SMP support as a normal
	kernel feature when most people won't have SMP anyway"
			-- Linus Torvalds


Only in this case I can't help feeling that the virtualisation work
already bypassed C/R, solved the problem space that a lot of people care
about and then moved on.

Alan
