Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1JMKq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:46:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59950 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1JMKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:46:27 -0400
Date: Thu, 13 Oct 2011 11:42:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [RFC 1/5] ARM: dev_archdata: add private iommu extension
Message-ID: <20111013104246.GA22076@n2100.arm.linux.org.uk>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <1316948337-7924-2-git-send-email-ohad@wizery.com> <CAK=Wgba6xxD2DBJhM--AcTPBoNRiOZ_6f8+j3bfaCqZMO8A4+w@mail.gmail.com> <CAK=Wgbau+XZ-c21FCT8DT0NYfm2uD6WZv3=cU2R23pV7LUkxEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=Wgbau+XZ-c21FCT8DT0NYfm2uD6WZv3=cU2R23pV7LUkxEA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:15:39AM +0200, Ohad Ben-Cohen wrote:
> On Wed, Oct 5, 2011 at 11:26 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > Hi Russell,
> >
> > On Sun, Sep 25, 2011 at 1:58 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> >> Add a private iommu pointer to the ARM-specific arch data in the
> >> device struct, which will be used to attach iommu-specific data
> >> to devices which require iommu support.
> >
> > Can you please take a look and ack/nack ?
> 
> gentle reminder

Ok, I'll take it if you put it in the patch system.

Thanks.
