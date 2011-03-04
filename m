Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab1CDVaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:30:25 -0500
Received: from kroah.org ([198.145.64.141]:38799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760096Ab1CDVaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:30:24 -0500
Date: Fri, 4 Mar 2011 13:23:36 -0800
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Igor M. Liplianin" <liplianin@me.by>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110304212336.GB27425@kroah.com>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au>
 <20110304171343.GE22173@kroah.com>
 <4D712750.1070402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D712750.1070402@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 02:54:24PM -0300, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Em 04-03-2011 14:13, Greg KH escreveu:
> > On Fri, Mar 04, 2011 at 04:39:05PM +1100, Stephen Rothwell wrote:
> >> Hi Greg,
> >>
> >> Today's linux-next merge of the staging tree got a conflict in
> >> drivers/staging/Kconfig between commit
> >> a1256092a1e87511c977a3d0ef96151cda77e5c9 ("[media] Altera FPGA firmware
> >> download module") from the v4l-dvb tree and commit
> >> 0867b42113ec4eb8646eb361b15cbcfb741ddf5b ("staging: gma500: Intel GMA500
> >> staging driver") from the staging tree.
> >>
> >> I fixed it up (see below) and can carry the fix as necessary.
> > 
> > That looks correct.
> > 
> > Mauro, what is this driver and why is it added to the staging tree?
> 
> This driver implements the FPGA programming logic for a firmware required
> by a DVB driver, and was proposed initially for 2.6.37 inclusion. During the
> 2.6.38 development cycle, it suffered several revisions, based on our input
> at the media and lkml mailing lists, where Igor fixed all CodingStyle issues.
> 
> In the last minute, during 2.6.38 merge window, two developers (Laurent and Ben) 
> [1] complained against adding a driver for loading FPGA firmware as-is. So, I
> decided to add it, for now, at staging, to avoid needing to postpone a long series 
> of patches again just because of that, especially since a series of DVB-C devices
> are without support on Linux without this patch series, and there are very few
> DVB-C devices currently supported.
> 
> The Altera driver is compliant with CodingStyle, and, from my side, it is ok
> to move it to drivers/others, but it doesn't hurt to give some time for Ben and 
> Laurent to propose alternative way of implementing the firmware request logic.
> 
> If nothing happens until 2.6.40 merge window, I think we should go forward and
> move it to the proper place.

Ok, thanks, I'll defer any patches for this code to you.

greg k-h
