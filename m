Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab1KABCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:02:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42023 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692Ab1KABCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:02:17 -0400
Date: Tue, 1 Nov 2011 01:02:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC
 bug.
Message-ID: <20111101010242.003738e9@lxorguk.ukuu.org.uk>
In-Reply-To: <CAC=G6sz=PkDoODYh4beT_eRhkm+ZhUxtLnrBXPPuFJW3n+6Vcg@mail.gmail.com>
References: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
	<20111027084310.2b7da753@pyx>
	<CAC=G6sz=PkDoODYh4beT_eRhkm+ZhUxtLnrBXPPuFJW3n+6Vcg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011 14:07:45 -0500
Paul Schilling <paul.s.schilling@gmail.com> wrote:

> Hi,
> 
> When I developed this patch for the Vortex86dx.  I recall trying many
> combinations of udma and mwdma.  At the time I developed it, I came
> to the conclusion that both udma and mwdma both failed with CRC
> errors being reported.

MWDMA does not have a CRC so that seems unlikely. If you can re-test and
we can figure out what is going on that would be useful.

Alan
