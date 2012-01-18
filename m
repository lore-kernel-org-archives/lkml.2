Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2ARLwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:52:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50216 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2ARLwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:52:10 -0500
Date: Wed, 18 Jan 2012 11:53:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Morell <rmorell@nvidia.com>
Cc: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: Expanding the use of DMA buffers in 3.3
Message-ID: <20120118115324.634bc940@pyramind.ukuu.org.uk>
In-Reply-To: <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-1-git-send-email-rmorell@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> in mind.  It would be unfortunate if restricting its use to only
> GPL-licensed modules caused dma-buf adoption to be limited.

You appear confused. I'll say this again is my lawyer advises me that for
the benefit of any future enforcement actions I should remind people
each time it comes up.

For a Linux kernel containing any code I own the code is under the GNU
public license v2 (in some cases or later), I have never given permission
for that code to be used as part of a combined or derivative work which
contains binary chunks. I have never said that modules are somehow
magically outside the GPL and I am doubtful that in most cases a work
containing binary modules for a Linux kernel is compatible with the
licensing, although I accept there may be some cases that it is.

Alan
