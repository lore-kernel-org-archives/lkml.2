Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1JMJaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:30:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57692 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1JMJad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:30:33 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <CAK=Wgba6xxD2DBJhM--AcTPBoNRiOZ_6f8+j3bfaCqZMO8A4+w@mail.gmail.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-2-git-send-email-ohad@wizery.com> <CAK=Wgba6xxD2DBJhM--AcTPBoNRiOZ_6f8+j3bfaCqZMO8A4+w@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 13 Oct 2011 11:15:39 +0200
Message-ID: <CAK=Wgbau+XZ-c21FCT8DT0NYfm2uD6WZv3=cU2R23pV7LUkxEA@mail.gmail.com>
Subject: Re: [RFC 1/5] ARM: dev_archdata: add private iommu extension
To: Russell King <linux@arm.linux.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 11:26 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Russell,
>
> On Sun, Sep 25, 2011 at 1:58 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> Add a private iommu pointer to the ARM-specific arch data in the
>> device struct, which will be used to attach iommu-specific data
>> to devices which require iommu support.
>
> Can you please take a look and ack/nack ?

gentle reminder
