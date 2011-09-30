Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1I3JGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:06:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32876 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001Ab1I3JGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:06:08 -0400
Date: Fri, 30 Sep 2011 10:04:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] x86 mrst: fix build error when X86_MRST is not
 enabled
Message-ID: <20110930100404.1a83ce65@lxorguk.ukuu.org.uk>
In-Reply-To: <4E84FC4D.3080506@xenotime.net>
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
	<4E84D684.107@xenotime.net>
	<20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
	<4E84FC4D.3080506@xenotime.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> arch/x86/platform/mrst/mrst.c -- where __mrst_cpu_chip lives --

In your tree yes

> is only built when CONFIG_X86_MRST is enabled.  You make it sound like
> __mrst_cpu_chip needs to live any time that CONFIG_X86_INTEL_MID
> is enabled, which sounds reasonable to me.
> 
> caveat:  given the current linux-next merge trees (as you mentioned).
> 
> Does anyone care?  If so, please help fix this muck.

It's already sorted, you are just seeing an out of order arrival of
patches to trees. I guess once kernel.org is back it'll all sort

