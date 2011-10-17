Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1JQWce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:32:34 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34630 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab1JQWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:32:20 -0400
X-Sasl-enc: CRylgHSvGUYG/vJ0q+XDPA5Qct7eXY17w9Bap+BPB98Y 1318890740
Date: Mon, 17 Oct 2011 15:20:55 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Marc Dietrich <marvin24@gmx.de>, Mikael Pettersson <mikpe@it.uu.se>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "Greg KH (gregkh@suse.de)" <gregkh@suse.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julian Andres Klode <jak@jak-linux.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Leon Romanovsky <leon@leon.nu>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>
Subject: Re: [PATCH] fix drivers/staging/nvec linkage error when keyboard is
 disabled
Message-ID: <20111017222055.GA2427@kroah.com>
References: <20112.34922.209107.730268@pilspetsen.it.uu.se>
 <1534774.fR3YHUzZE9@fb07-iapwap2>
 <74CDBE0F657A3D45AFBB94109FB122FF173B23B539@HQMAIL01.nvidia.com>
 <20111017222019.GA2410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017222019.GA2410@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 03:20:19PM -0700, Greg KH wrote:
> On Mon, Oct 10, 2011 at 10:25:07AM -0700, Stephen Warren wrote:
> > Marc Dietrich wrote at Sunday, October 09, 2011 9:48 AM:
> > > Hi Mikael,
> > > 
> > > thanks for review. The nvec driver received some overhaul in the 3.1 release cycle
> > > and he fruids can be viewed in linux-next tree. The nvec client drivers were
> > > converted to mfd children in the mean time. This solves the build error, but is not
> > > very flexible. We are planing to move the mfd stuct to the board file(s) in the next
> > > cycle.
> > 
> > Indeed, the code in v3.1-rc9 is quite different to that in linux-next, so
> > this exact problem doesn't exist in linux-next.
> > 
> > However, don't we still want to solve build problems for the final v3.1
> > release, or a stable update to that? As such,
> > 
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > 
> > I also CC'd the staging maintainer Greg KH and Tegra maintainers Olof and
> > Colin on this email.
> 
> I'm confused, what patch should I apply here?  Can someone please resend
> it in a format that I can apply it in?  With the proper acks?

Nevermind, it already was, sorry for the noise...

