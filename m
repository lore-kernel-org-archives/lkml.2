Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0IAJoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:44:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52355 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320Ab0IAJoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:44:17 -0400
Date: Wed, 1 Sep 2010 11:02:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Joe Perches <joe@perches.com>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Message-ID: <20100901110214.427bfdc3@lxorguk.ukuu.org.uk>
In-Reply-To: <1283300616.3284.213.camel@dhcp231-106.rdu.redhat.com>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	<1282837904.1875.64.camel@Joe-Laptop>
	<20100826161451.GB2367@linux.vnet.ibm.com>
	<1282839933.8133.11.camel@mulgrave.site>
	<20100826092923.4bdbea69.rdunlap@xenotime.net>
	<20100826093838.74ab9958@infradead.org>
	<1283275388.1377.216.camel@gandalf.stny.rr.com>
	<20100831230213.GG2421@linux.vnet.ibm.com>
	<1283296622.1377.765.camel@gandalf.stny.rr.com>
	<987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com>
	<1283298391.1797.100.camel@Joe-Laptop>
	<1283300616.3284.213.camel@dhcp231-106.rdu.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I just downloaded a big tar ball and started trolling randomly
> through the source how am I going to know what the MAINTAINERS file is?

Probably because you started with Documentation/* which explains it in
SubmittingPatches for one ?

> I just think that hoping a newbie is going to naturally know MAINTAINERS
> isn't the best.

If they can't find the MAINTAINERS file in the top level directory, and
haven't read SubmittingPatches either then maybe that's not a complete
disaster at that point ?
