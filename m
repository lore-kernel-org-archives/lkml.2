Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab0I0PXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:23:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48427 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab0I0PXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OOPqrcjhtAXtvDnY/G+ilQJy6BX3c9gib3KYwJhcIAU4GzHlys1Qexb4NJM3YDbBzs
         8XYDxxAiFaVjA0NL6mXVXxmoDNymai5cVnVTIUaKImYhCqFr/Ii6WQ/UObyaHdKt7qps
         YrXkF4k9Pl+DNrW/YgB6hdM0wQKSrfIOTV5CY=
MIME-Version: 1.0
In-Reply-To: <1285370032-16937-2-git-send-email-iws@ovro.caltech.edu>
References: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
	<1285370032-16937-2-git-send-email-iws@ovro.caltech.edu>
Date: Mon, 27 Sep 2010 17:23:34 +0200
Message-ID: <AANLkTimzdEhAZ=oXbbB3Ge5=YY7OXq3fjaRH4roPNB-k@mail.gmail.com>
Subject: Re: [PATCH RFCv2 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/25 Ira W. Snyder <iws@ovro.caltech.edu>:

> This adds support for scatterlist to scatterlist DMA transfers.

This is a good idea, we have a local function to do this in DMA40 already,
stedma40_memcpy_sg().

> This is
> currently hidden behind a configuration option, which will allow drivers
> which need this functionality to select it individually.

Why? Isn't it better to add this as a new capability flag
if you don't want to announce it? Or is the intent to save
memory footprint?

Yours,
Linus Walleij
