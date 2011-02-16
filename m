Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab1BPFzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 00:55:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1BPFzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 00:55:39 -0500
Date: Tue, 15 Feb 2011 22:55:36 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Add missing of_address.h to xilinx ehci driver
Message-ID: <20110216055536.GB22236@angua.secretlab.ca>
References: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
 <20110215204011.GB24022@angua.secretlab.ca>
 <AANLkTi=j4COunaLvadkD8Oh2qGaBCsNb8DvrKt_C4GHf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=j4COunaLvadkD8Oh2qGaBCsNb8DvrKt_C4GHf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:58:26AM +1000, John Williams wrote:
> On Wed, Feb 16, 2011 at 6:40 AM, Grant Likely <grant.likely@secretlab.ca>wrote:
> 
> > On Mon, Feb 14, 2011 at 11:40:09AM +0100, Michal Simek wrote:
> > > Build log:
> > > In file included from drivers/usb/host/ehci-hcd.c:1208:
> > > drivers/usb/host/ehci-xilinx-of.c: In function
> > 'ehci_hcd_xilinx_of_probe':
> > > drivers/usb/host/ehci-xilinx-of.c:168: error: implicit declaration of
> > function 'of_address_to_resource'
> > >
> > > Signed-off-by: John Williams <john.williams@petalogix.com>
> > > Signed-off-by: Michal Simek <monstr@monstr.eu>
> >
> > Applied, thanks.
> >
> 
> FYI I haven't tried building it, but I believe that ehci-ppc-of.c will need
> the same patch.

I'll wait for someone to post a patch.

g.

