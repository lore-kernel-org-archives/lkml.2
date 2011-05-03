Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab1ECIvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:51:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42228 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521Ab1ECIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:51:19 -0400
Date: Tue, 3 May 2011 09:52:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: suman <vijayendra.suman@gmail.com>
Cc: kraxel@goldbach.in-berlin.de, linux-kernel@vger.kernel.org,
        sankar.r@samsung.com
Subject: Re: Vesafb - need double framebuffer
Message-ID: <20110503095220.0325028e@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=7N=vrj1S8-=wvVieTss-SnBfXew@mail.gmail.com>
References: <BANLkTi=7N=vrj1S8-=wvVieTss-SnBfXew@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am trying to develop a qt UI for this i need to have another
> framebuffer /dev/fb1, how can i add one more fb, should i use
> framebuffer_alloc function to allocate a new frame buffer. Do you have
> any patch for providing two frame buffers in case of vesafb driver. I
> have tried on net and i failed to find any suitable patch for the

VESA only supports the BIOS initialized framebuffer on a PC - you need a
frame buffer or KMS capable interface specific to whatever chipset you
are using that can initialize the chipset from boot.

