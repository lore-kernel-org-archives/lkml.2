Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab1LIWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:35:00 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36837 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1LIWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:34:59 -0500
X-Sasl-enc: ESvN2DnFNJDUx2QIBUSb7KZT4C3NTLrzADLuLETh0KM8 1323470098
Date: Fri, 9 Dec 2011 14:34:54 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
Message-ID: <20111209223454.GA24987@kroah.com>
References: <1323309517.979.8.camel@mop>
 <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323444321.979.39.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 04:25:21PM +0100, Kay Sievers wrote:
> Greg, would be nice, if you can take a quick look a the driver core (not
> the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
> they look sane to you. I'll then split the driver core stuff out, so we
> can merge that before we port the individual drivers over.

Yes, it looks sane to me, thanks again for doing this work.

greg k-h
