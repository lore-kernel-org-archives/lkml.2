Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1FHKq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:46:58 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48095 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1FHKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:46:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 2/6] omap: iovmm: generic iommu api migration
Date: Wed, 8 Jun 2011 12:46:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <201106071326.53106.laurent.pinchart@ideasonboard.com> <BANLkTimqt=yMGHcqEH5u-4GkMX9=+BuB6A@mail.gmail.com>
In-Reply-To: <BANLkTimqt=yMGHcqEH5u-4GkMX9=+BuB6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106081246.53106.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tuesday 07 June 2011 15:46:26 Ohad Ben-Cohen wrote:
> On Tue, Jun 7, 2011 at 2:26 PM, Laurent Pinchart wrote:
> >> Right now we have a BUG_ON if pa is unaligned, but that can be changed
> >> if needed (do we want it to handle offsets ?).
> > 
> > At least for the OMAP3 ISP we need to, as video buffers don't necessarily
> > start on page boundaries.
> 
> Where do you take care of those potential offsets today ? Or do you
> simply ignore the offsets and map the entire page ?

Here http://marc.info/?l=linux-omap&m=130693502326513&w=2 :-)

> Seems like omap's iommu (mostly) rejects unaligned pa addresses, see:
> 
> 4abb761749abfb4ec403e4054f9dae2ee604e54f "omap iommu: Reject unaligned
> addresses at setting page table entry"
> 
> (this doesn't seem to cover 4KB entries though, only large pages,
> sections and super sections)
> 
> > A separate patch is indeed needed, yes. As you're already working on
> > iommu it might be simpler if you add it to your tree.
> 
> Sure, i'll send it.

-- 
Regards,

Laurent Pinchart
