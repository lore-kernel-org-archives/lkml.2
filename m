Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0HRRPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:15:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44415 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393Ab0HRRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:15:29 -0400
Date: Wed, 18 Aug 2010 18:31:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pascal GREGIS <pgs@synerway.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ata_sff_drain_fifo
Message-ID: <20100818183106.152cb8ca@lxorguk.ukuu.org.uk>
In-Reply-To: <20100818162329.GC3029@gaiman.synerway.com>
References: <20100818094313.GA3333@gaiman.synerway.com>
	<20100818124412.4652eaea@lxorguk.ukuu.org.uk>
	<20100818162329.GC3029@gaiman.synerway.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. I also noticed that qc->dma_dir=DMA_TO_DEVICE which also prevents the draining.
> I thought it could be a solution for certain problems like mine where the device is busy but the reset doesn't work which brings to a blocking point, but no.

It shouldn't unless there is a specific IDE controller need to drain
data. You could try it and see what it does but I doubt it will help -
but who knows 8)
