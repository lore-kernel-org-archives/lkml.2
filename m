Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1BJTW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:22:58 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44685 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755870Ab1BJTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:22:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KtuuMIiMRBF/Qk+r9K4dXcnmJO2g6KEHiMQHN6iKyCaJDAMQaW0PhxUE891XOpscBYJ5lJdH4Od9luffUsOGbWzg3GHS2rpqCgmMRlAr8KPwa930f2HjTvBgy7MHReLl;
Date: Thu, 10 Feb 2011 11:22:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/30] amd64_edac: Add Bulldozer support
Message-ID: <20110210112249.255aa016@jbarnes-desktop>
In-Reply-To: <20110210192034.GI12244@aftab>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
	<20110210185637.GA16128@kroah.com>
	<20110210192034.GI12244@aftab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 20:20:34 +0100
Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Feb 10, 2011 at 01:56:37PM -0500, Greg KH wrote:
> > On Thu, Feb 10, 2011 at 06:15:03PM +0100, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Hi all,
> > > 
> > > the following patchset that adds support for our upcoming F15h CPUs.
> > > Besides adding a new family support, it cleans up a lot in the driver
> > > and the diffstat says it all:
> > > 
> > >  arch/x86/kernel/amd_nb.c      |    2 +-
> > >  drivers/edac/amd64_edac.c     | 1412 +++++++++++++++++++----------------------
> > >  drivers/edac/amd64_edac.h     |  357 ++++-------
> > >  drivers/edac/amd64_edac_inj.c |    8 +-
> > >  drivers/edac/edac_mc_sysfs.c  |   26 +-
> > >  drivers/edac/mce_amd.c        |    8 +-
> > >  drivers/edac/mce_amd.h        |   28 +-
> > >  include/linux/pci_ids.h       |    2 +-
> > >  8 files changed, 825 insertions(+), 1018 deletions(-)
> > > 
> > > @Greg/@Ingo: Guys, let me know if patch 27/30 should be rerouted over
> > > your trees or would you rather like to ACK it?
> > 
> > I don't need to ack it or take it as it doesn't pertain to any of the
> > files I maintain :)
> 
> Ah, sorry for the confusion, it should be Jesse Barnes instead, added to
> Cc.
> 
> Jesse, do you want the patch at
> http://marc.info/?l=linux-edac&m=129735827731488&w=2 rerouted over your
> tree or would you rather ack it?

You can have my ack:

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Though if that's the only place that PCI ID is used, you may as well
just put it into the corresponding file and remove it from pci_ids.h
altogether.

-- 
Jesse Barnes, Intel Open Source Technology Center
