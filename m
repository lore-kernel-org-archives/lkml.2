Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2B2Xua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:50:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53428 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2B2Xu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:50:29 -0500
Date: Wed, 29 Feb 2012 23:52:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Message-ID: <20120229235217.494d49d8@pyramind.ukuu.org.uk>
In-Reply-To: <201202292018.45557.arnd@arndb.de>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
	<201202292018.45557.arnd@arndb.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 20:18:45 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 29 February 2012, Eric Andersson wrote:
> > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > generation of pressure sensors called BMP18x. These pressure sensors can be
> > connected on I2C but also on SPI as a variant, so the driver implements both.
> > Register-wise they are fully compatible with the older BMP085, so the driver will
> > support those chips as well.
> > 
> > The driver is based on bmp085.c by Christoph Mair.
> 
> Hmm,  the implementation looks fine, but I don't think we should add support
> for new devices with a one-off interface that we know is getting replaced by
> something generic.
> 
> Why is this not using IIO for its user interface?

This is become a repeating problem

Either get the IIO layer out of staging (where it appears to have
congealed) or stop asking people to use it. IIO stuck in staging is
becoming a problem not a cure. It's creating uncertainty blocking lots of
stuff that needs to get upstream and that current stream is going to
become a tide post Android merging.

It needs resolving one way or the other and soon.

Alan
