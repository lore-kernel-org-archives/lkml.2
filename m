Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1BJTUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:20:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49812 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1BJTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:20:16 -0500
Date: Thu, 10 Feb 2011 20:20:34 +0100
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/30] amd64_edac: Add Bulldozer support
Message-ID: <20110210192034.GI12244@aftab>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
 <20110210185637.GA16128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210185637.GA16128@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:56:37PM -0500, Greg KH wrote:
> On Thu, Feb 10, 2011 at 06:15:03PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Hi all,
> > 
> > the following patchset that adds support for our upcoming F15h CPUs.
> > Besides adding a new family support, it cleans up a lot in the driver
> > and the diffstat says it all:
> > 
> >  arch/x86/kernel/amd_nb.c      |    2 +-
> >  drivers/edac/amd64_edac.c     | 1412 +++++++++++++++++++----------------------
> >  drivers/edac/amd64_edac.h     |  357 ++++-------
> >  drivers/edac/amd64_edac_inj.c |    8 +-
> >  drivers/edac/edac_mc_sysfs.c  |   26 +-
> >  drivers/edac/mce_amd.c        |    8 +-
> >  drivers/edac/mce_amd.h        |   28 +-
> >  include/linux/pci_ids.h       |    2 +-
> >  8 files changed, 825 insertions(+), 1018 deletions(-)
> > 
> > @Greg/@Ingo: Guys, let me know if patch 27/30 should be rerouted over
> > your trees or would you rather like to ACK it?
> 
> I don't need to ack it or take it as it doesn't pertain to any of the
> files I maintain :)

Ah, sorry for the confusion, it should be Jesse Barnes instead, added to
Cc.

Jesse, do you want the patch at
http://marc.info/?l=linux-edac&m=129735827731488&w=2 rerouted over your
tree or would you rather ack it?

Same question for Ingo, for the <arch/x86/kernel/amd_nb.c> part.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
