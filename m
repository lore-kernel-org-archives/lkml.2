Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1CNXI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:08:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55477 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751499Ab1CNXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:08:28 -0400
Date: Mon, 14 Mar 2011 23:05:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 11/12] driver: Google EFI SMI
Message-ID: <20110314230543.5b668ed2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110314201346.GA1084@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
	<20110312014353.6133.94204.stgit@mike.mtv.corp.google.com>
	<20110314154713.GF31340@kroah.com>
	<AANLkTikhhYv2=memo-Rkhh1pG3v4-edrUROTgLoc6cbd@mail.gmail.com>
	<20110314201346.GA1084@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I don't know if there is a good way to have this guy autoloaded, but
> > that's probably fine. We will likely compile it in as a built-in or
> > adjust our userland to have the module loaded.  We use it on all
> > machines we've been building for the last 4-5 years, and a table of
> > device IDs would just contain a list of a bunch of parts that aren't
> > really google-specific.
> 
> What's wrong with using DMI strings?  Are there going to be that many
> different ones of them here?

If you've got them in the ACPI tables that's as good as DMI if not better
IMHO
