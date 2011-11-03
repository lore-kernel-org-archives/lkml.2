Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1KCXS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:18:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56029 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598Ab1KCXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:18:25 -0400
Date: Thu, 3 Nov 2011 23:19:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC
 bug.
Message-ID: <20111103231904.11767480@lxorguk.ukuu.org.uk>
In-Reply-To: <CAC=G6sxZ10ben3R5X2aKGi6q3a68+c0CO+mG=+kUeUvKoRbOJg@mail.gmail.com>
References: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
	<20111027084310.2b7da753@pyx>
	<CAC=G6sz=PkDoODYh4beT_eRhkm+ZhUxtLnrBXPPuFJW3n+6Vcg@mail.gmail.com>
	<20111101010242.003738e9@lxorguk.ukuu.org.uk>
	<CAC=G6sxZ10ben3R5X2aKGi6q3a68+c0CO+mG=+kUeUvKoRbOJg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [   33.822836] ata2: lost interrupt (Status 0x58)
> [   33.824367] ata2: drained 2048 bytes to clear DRQ

So you have a different problem - your IRQ delivery appears to be broken.

