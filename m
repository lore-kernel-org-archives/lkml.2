Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab2EOPjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:39:02 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45378 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2EOPjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:39:00 -0400
Date: Tue, 15 May 2012 16:41:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515164143.3e8a8d04@pyramind.ukuu.org.uk>
In-Reply-To: <20120515152942.GH6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
	<20120515111255.GJ32036@redhat.com>
	<4FB23C09.7060300@suse.de>
	<20120515115917.GK32036@redhat.com>
	<20120515150015.5bf17aea@pyramind.ukuu.org.uk>
	<20120515143644.GD6948@redhat.com>
	<20120515155206.520e46b6@pyramind.ukuu.org.uk>
	<20120515145316.GF6948@redhat.com>
	<20120515162226.1b9a7496@pyramind.ukuu.org.uk>
	<20120515152942.GH6948@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, will work if standard I/O addresses are used for master/slave, but
> I do not see this information be exposed via /sys by EDD. So how can I
> do it from OS installer with current kernel or kernel with reverted
> patch?

I don't think we provide the needed info for this (or EDD 2.1 which I've
just discovered actually shipped in some plug in boards). Not sure 2.1 is
around online anywhere.

Thats a separate problem though.

My big concern is that we are sure it disappearing won't break anything.
It's been noticed at SuSE so it's obviously not entiely invisible.

I'd love to see EDD 1.1 and 2.1 support in the kernel as I could then
merge pata_hdd which drives original MFM/RLL drives. However I don't
believe its worth the effort unlike doing 3.0 right.

Alan
