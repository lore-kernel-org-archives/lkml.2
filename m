Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2EOOQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:16:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45115 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2EOOQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:16:00 -0400
Date: Tue, 15 May 2012 15:18:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515151849.54a12175@pyramind.ukuu.org.uk>
In-Reply-To: <20120515141214.GB6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
	<20120515111255.GJ32036@redhat.com>
	<4FB23C09.7060300@suse.de>
	<20120515115917.GK32036@redhat.com>
	<20120515144945.339e742f@pyramind.ukuu.org.uk>
	<20120515141214.GB6948@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 17:12:14 +0300
Gleb Natapov <gleb@redhat.com> wrote:

> On Tue, May 15, 2012 at 02:49:45PM +0100, Alan Cox wrote:
> > > I do not see support for other spec to be important, but you are welcome
> > > to write support for it if you need it. The only way I see to check what
> > > spec edd info corresponds to is to calculate checksum according to both
> > > specs and see which one succeeds.
> > 
> > No it doesn't work like that. This is a regression for existing working
> > systems. It needs to be reverted or fixed. If it was a new feature you'd
> > have a point - but it isn't. You've broken stuff, undo the breakage.
> > 
> Code never supported anything but EDD4.0 spec. I checked history git.
> Code erroneously tried to interpret EDD3.0 info according to EDD4.0 spec
> providing garbage as a result.

Providing some valid data and info, which has now disappeared.

So I still think this is a regression. It wants fixing properly and that
patch should be reverted until it has been done right.
