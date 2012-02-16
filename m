Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2BPLJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:09:05 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53752 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BPLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:09:03 -0500
Date: Thu, 16 Feb 2012 11:10:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aneesh V <aneesh@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/8] misc: ddr: add LPDDR2 data from JESD209-2
Message-ID: <20120216111043.3256189f@pyramind.ukuu.org.uk>
In-Reply-To: <4F3CDA2D.2060001@ti.com>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
	<1328357771-31644-3-git-send-email-aneesh@ti.com>
	<4F3CD55C.2020002@ti.com>
	<4F3CDA2D.2060001@ti.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 15:57:57 +0530
Aneesh V <aneesh@ti.com> wrote:

> On Thursday 16 February 2012 03:37 PM, Santosh Shilimkar wrote:
> > On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
> >> add LPDDR2 data from the JEDEC spec JESD209-2. The data
> >> includes:
> >>
> >> 1. Addressing information for LPDDR2 memories of different
> >>     densities and types(S2/S4)
> >> 2. AC timing data.
> >>
> >> This data will useful for memory controller device drivers

I don't think it belongs in drivers/misc. It's not a driver but a
library. lib/ might be a better place for it perhaps ?

Alan
