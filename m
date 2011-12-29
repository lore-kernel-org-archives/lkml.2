Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1L2MY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 07:24:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42263 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1L2MYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 07:24:22 -0500
Date: Thu, 29 Dec 2011 12:25:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Mark Allyn <mark.a.allyn@intel.com>
Subject: Re: [PATCH] sep: SEP update
Message-ID: <20111229122502.540c6f7f@pyramind.ukuu.org.uk>
In-Reply-To: <1325110478.16729.7.camel@joe2Laptop>
References: <20111228173748.3323.89307.stgit@bob.linux.org.uk>
	<1325110478.16729.7.camel@joe2Laptop>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Dec 2011 14:14:38 -0800
Joe Perches <joe@perches.com> wrote:

> On Wed, 2011-12-28 at 17:37 +0000, Alan Cox wrote:
> > From: Mark Allyn <mark.a.allyn@intel.com>
> > The new driver supports the kernel crypto layer, passes the coding style checks,
> > passes human taste checks and has proper kernel-doc formatted comments.
> 
> These are just taste comments.

Not so sure about the switch case one but the others I concur - I'll send
Greg a follow up patch once the main one is merged.

Alan
