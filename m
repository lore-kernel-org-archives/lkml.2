Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1IZWxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:53:32 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44646 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab1IZWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:53:30 -0400
From: Kevin Hilman <khilman@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Cousson Benoit <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu private archdata
Organization: Texas Instruments, Inc.
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
	<1316948337-7924-3-git-send-email-ohad@wizery.com>
Date: Mon, 26 Sep 2011 15:53:22 -0700
In-Reply-To: <1316948337-7924-3-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Sun, 25 Sep 2011 13:58:54 +0300")
Message-ID: <87sjni9aql.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Ohad Ben-Cohen <ohad@wizery.com> writes:

> Make it possible to set an iommu private archdata before a newly-created
> omap device is registered.
>
> Binding iommu client devices with their respective iommu data this way
> is needed so the generic IOMMU API can later be used without employing
> any omap-specific IOMMU plumbing.
>
> This patch just crudely adds an omap_device_build_ss_ext() method which
> accepts an iommu private data, but we may actually want to do something
> more generic here: e.g., split the omap_device_build API to alloc+add
> methods, so users can just manipulate the device as needed before it is
> registered (very much like we can do with plain devices).

Yes indeed.  

Benoit did just this in preparation for DT. 

       http://marc.info/?l=linux-omap&m=131672480111927&w=2

Will that meet your needs?

Kevin
