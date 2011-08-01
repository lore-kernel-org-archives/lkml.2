Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1HAPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:37:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57172 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751826Ab1HAPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:37:04 -0400
Date: Mon, 1 Aug 2011 16:39:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mrst_pmu: driver for Intel Moorestown Power Management
 Unit
Message-ID: <20110801163938.74d03c2d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1108011116160.23581@x980>
References: <alpine.LFD.2.02.1107122328180.4502@x980>
	<20110713105105.63e2fbcb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.02.1108011116160.23581@x980>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Aug 2011 11:24:45 -0400 (EDT)
Len Brown <lenb@kernel.org> wrote:

> 
> > > +	BUG_ON(pci_dev_num != mrst_devs[index].pci_dev_num);
> > 
> > That strikes me as needlessly unfriendly, you could warn/return NULL and
> > propogate a WARN_ONCE back to the user.
> 
> If a fit of friendlyness, I wrote the patch below.
> Let me know if it is not what you had in mind.

It's not so much the bug on as the fact it spews these if you boot it on
a non mrst box built with a generic kernel - which was the second part of
my comment and doesn't appear addressed.
