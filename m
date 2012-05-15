Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2EOOox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:44:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45179 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab2EOOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:44:52 -0400
Date: Tue, 15 May 2012 15:47:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, <stable@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [34-longterm 179/179] x86/PCI: do not tie MSI MS-7253 use_crs
 quirk to BIOS version
Message-ID: <20120515154743.04879bde@pyramind.ukuu.org.uk>
In-Reply-To: <20120515154455.39cfbad2@pyramind.ukuu.org.uk>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
	<1337048075-6132-180-git-send-email-paul.gortmaker@windriver.com>
	<20120515154455.39cfbad2@pyramind.ukuu.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 15:44:55 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> O> MS-7253, for which we already have a quirk, but the short-sighted
> > author tied the quirk to a single BIOS version, making it not kick in
> 
> It's our usual policy to tie to particular BIOS versions because these
> things are often BIOS specific and come and go with updates.

Doh ignore that, the point is valid but not in a -longterm context
