Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab0HQJty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:49:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55352 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756784Ab0HQJtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:49:52 -0400
Date: Tue, 17 Aug 2010 11:04:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Lytochkin Boris <lytboris@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] serial: 8250pci: Recast inb return value
Message-ID: <20100817110435.45e6ed8b@lxorguk.ukuu.org.uk>
In-Reply-To: <1282031947-16483-2-git-send-email-monstr@monstr.eu>
References: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
	<1282031947-16483-2-git-send-email-monstr@monstr.eu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:59:07 +0200
Michal Simek <monstr@monstr.eu> wrote:

> inb returns u8 that's why is necessary to do recast.

ret is an int, inb returns a u8, neither are pointers and the cast
required is implict and defined by the spec.


> drivers/serial/8250_pci.c: In function 'pci_ite887x_init':
> drivers/serial/8250_pci.c:825: warning: cast to pointer from integer of different size
