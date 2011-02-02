Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1BBWY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:24:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58962 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755159Ab1BBWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:24:54 -0500
Date: Wed, 2 Feb 2011 22:26:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net> (maintainer:SPI
	SUBSYSTEM),
        Grant Likely <grant.likely@secretlab.ca> (maintainer:SPI SUBSYSTEM),
        spi-devel-general@lists.sourceforge.net (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/1] spi: intel_mid_ssp_spi: new SPI driver for intel
 Medfield platform
Message-ID: <20110202222652.6b811f56@lxorguk.ukuu.org.uk>
In-Reply-To: <1296680512-2758-2-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011>
	<1296680512-2758-2-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Feb 2011 13:01:52 -0800
Russ Gorby <russ.gorby@intel.com> wrote:

> SPI master controller driver for the Intel MID platform Medfield
> This driver uses the Penwell SSP controller and configures it to
> be a SPI device (spibus 3). This bus supports a single device -
> the 3G SPI modem that can operate up to 25Mhz.

NAK this.

We have an existing development driver that covers 0x0815, 0x0816, 0x0825,
0x0832 in a single driver which needs tidying up and double checking on
all the relevant Medfield and Moorestown devices and is based on work done
by Mathieu Soulard.

All these devices can be handled by a single driver, and should be.

Alan
