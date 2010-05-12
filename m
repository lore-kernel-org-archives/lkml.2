Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0ELDow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:44:52 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:36593 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0ELDov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:44:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv2 2.6.34-rc7 2/3] mx5: change usb clock source from pll3 to pll2
Date: Tue, 11 May 2010 20:44:42 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851048701E6@az33exm21>
In-Reply-To: <20100511233221.GA31311@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2 2.6.34-rc7 2/3] mx5: change usb clock source from pll3 to pll2
Thread-Index: AcrxY2kSKZmG7DokRuGyKKeSj4i2YAAIbMiQ
References: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com> <1273508519-23033-2-git-send-email-Dinh.Nguyen@freescale.com> <20100511233221.GA31311@kroah.com>
From: "Nguyen Dinh-R00091" <R00091@freescale.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
       <linux-usb@vger.kernel.org>, <s.hauer@pengutronix.de>,
       <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
       <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
       <amit.kucheria@canonical.com>, "Li Jun-R65092" <R65092@freescale.com>,
       "Zhang Lily-R58066" <R58066@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 11:21:58AM -0500, Dinh Nguyen wrote:
> For power management reasons, pll2 should be used to source the USBOH3

> clock for mx51. PLL3 can be completely gated off when USB is not used.
> 
> This patch applies to 2.6.34-rc7.

On Tuesday, May 11, 2010 6:32 PM , Greg KH wroe:
> Hm, no, it seems to conflict and does not apply :(

>I've taken the first one, shouldn't the two others go through some arm
tree?

It looks like Sascha has taken the patch 2/3 and 3/3. Thanks, Dinh

