Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab1JGKEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:04:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53824 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157Ab1JGKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:04:51 -0400
Date: Fri, 7 Oct 2011 11:02:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111007110243.05115778@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
References: <20111006190526.GA13883@redhat.com>
	<20111006194432.GA21642@kroah.com>
	<20111006195007.GA24900@redhat.com>
	<20111006195824.GA22033@kroah.com>
	<20111006200440.GB25681@redhat.com>
	<alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What stops virtualbox developers from renaming the module in every 
> release? That's the same story.
> 
> The only fool-proof way of doing is indeed is the GPG-signing thing.

If you want to get into a sophisticated fight with someone over hiding
the presence of a module then that's a pointless exercise.

If you want to just make it easier to sort and detect out of tree modules
then fine but the only actual pressure you have controlling its
effectiveness is going to be the embarrasment of a vendor who gets caught
out. GPG is thus I think over-engineering it somewhat.

Alan
