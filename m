Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2ARLrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:47:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46593 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2ARLrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:47:23 -0500
Date: Wed, 18 Jan 2012 11:48:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Morell <rmorell@nvidia.com>
Cc: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20120118114835.73396d24@pyramind.ukuu.org.uk>
In-Reply-To: <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-1-git-send-email-rmorell@nvidia.com>
	<1326845297-6233-2-git-send-email-rmorell@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 16:08:17 -0800
Robert Morell <rmorell@nvidia.com> wrote:

> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> issue, and not really an interface".  The dma-buf infrastructure is
> explicitly intended as an interface between modules/drivers, so it
> should use EXPORT_SYMBOL instead.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

Please get a Signed-off-by: from the original authors. In some eyes you
are making what is a licensing change, and that needs the rights holders
permissions.

So this patch at the very least needs approval from TI and Linaro.



