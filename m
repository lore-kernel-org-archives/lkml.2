Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2JVPjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:39:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48930 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2JVPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:39:52 -0400
Date: Mon, 22 Oct 2012 16:44:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Jackson <ajax@redhat.com>
Cc: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org,
        Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-pci@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: radeon: RFC speed cap detection on ppc64
Message-ID: <20121022164444.2b0775ce@pyramind.ukuu.org.uk>
In-Reply-To: <508565FA.4040908@redhat.com>
References: <50819140.8030806@linux.vnet.ibm.com>
	<508565FA.4040908@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That (walking all parent nodes) is probably the safest thing to do.  I'm 
> not sure whether it's optimal.  It would likely depend on whether you 
> can meaningfully have a bridge that's faster on the downstream side than 
> on the upstream.

This is architecture goo at heart - would this be better as a helper in
the PCI and arch PCI code ?

Alan
