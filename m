Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1JLR75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:59:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45982 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751906Ab1JLR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:59:55 -0400
Date: Wed, 12 Oct 2011 18:55:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pata_cmd64x: remove dead CMD646 rev 1 code
Message-ID: <20111012185507.0f0b49b0@lxorguk.ukuu.org.uk>
In-Reply-To: <201110121722.50358.bzolnier@gmail.com>
References: <201110111959.04056.bzolnier@gmail.com>
	<20111011205803.0c696a21@lxorguk.ukuu.org.uk>
	<201110121722.50358.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cmd646r1_bmdma_stop() just calls the standard ata_bmdma_stop()
> helper and it has been the case since the driver introduction
> by commit 669a5db ("[libata] Add a bunch of PATA drivers.") in
> Aug 2006.

The question that was asked before I seem to remember was whehter it
should be using its own helper. As libata reads the status first it
shouldn't so this seems ok

But this should all be documented in the changelog or god knows how
someone will figure it out in 18 months time if they end up bisecting to
it.

