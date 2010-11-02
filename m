Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0KBQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:30:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43488 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259Ab0KBQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:30:14 -0400
Date: Tue, 2 Nov 2010 16:29:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Greg KH <greg@kroah.com>, Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101102162922.5864724b@lxorguk.ukuu.org.uk>
In-Reply-To: <4CD03886.5030502@synaptics.com>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
	<20101102140337.GC9387@kroah.com>
	<4CD03886.5030502@synaptics.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I must confess that I am seriously confused as to why this patch should 
> be considered for fast tracking into the "real" kernel.  It's based on 

Because its usable, it works and people want to be able to use their
hardware.

> an implementation that wasn't considered suitable for the "real" kernel, 
> and doesn't address the concerns relating to that.  If "merge it now, 
> fix it later" wasn't an acceptable approach previously, is there some 
> compelling reason it is now acceptable?

staging is different to putting it in drivers/input/

> On the other hand, I totally understand frustration with our slow rate 
> of output.  We're trying to produce the best possible code, but this is 
> not happening as quickly as any of us would like.

And in the mean time we've got an acceptable driver that works and which
we are happy to pitch overboard once the masterpiece appears. Until then
people would like to use their hardware.

Alan
