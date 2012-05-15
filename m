Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2EOOtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:49:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45195 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab2EOOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:49:18 -0400
Date: Tue, 15 May 2012 15:52:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515155206.520e46b6@pyramind.ukuu.org.uk>
In-Reply-To: <20120515143644.GD6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
	<20120515111255.GJ32036@redhat.com>
	<4FB23C09.7060300@suse.de>
	<20120515115917.GK32036@redhat.com>
	<20120515150015.5bf17aea@pyramind.ukuu.org.uk>
	<20120515143644.GD6948@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is easy to be confused since there are two EDD 3 specs. First is from
> Phoenix BIOS (linked at the first mail of the thread) and it does not have
> enough info even for ATA. You can't tell primary ATA controller from secondary.

Yes you can - it's defined by the PCI specification for compatibility
mappings on hardware of that era. Once you move to newer systems with ATA
native PCI controllers then you need the 3.0 spec not the Phoenix spec.

Alan
