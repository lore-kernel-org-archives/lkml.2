Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404Ab0GSQVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 12:21:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39523 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936320Ab0GSQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 12:21:39 -0400
Date: Mon, 19 Jul 2010 17:31:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh@suse.de, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 9 (serial/max3107)
Message-ID: <20100719173113.4cce1a03@lxorguk.ukuu.org.uk>
In-Reply-To: <20100719091604.c513b2d5.randy.dunlap@oracle.com>
References: <20100709150117.51612026.sfr@canb.auug.org.au>
	<20100711152723.a8a3ad74.randy.dunlap@oracle.com>
	<20100719091604.c513b2d5.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > when CONFIG_GPIOLIB is not enabled:
> > 
> > drivers/serial/max3107.h:372: error: field 'chip' has incomplete type
> 
> 
> This build still fails in linux-next 20100719.

I'll put next tonight and have a detailed look at this one.

Alan
