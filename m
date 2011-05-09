Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1EIJDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:03:44 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:40823 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab1EIJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:03:43 -0400
Date: Mon, 9 May 2011 12:03:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: balbi@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304867317.3246.10.camel@odin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 08, 2011 at 04:08:37PM +0100, Liam Girdwood wrote:
> On Wed, 2011-04-27 at 13:45 +0300, Felipe Balbi wrote:
> > Hi,
> > 
> > On Wed, Apr 27, 2011 at 10:39:51AM +0100, Graeme Gregory wrote:
> > > The twl6025 uses a different regulator for USB than the 6030 so select
> > > the correct regulator name depending on the subclass of device.
> > > 
> > > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > 
> > I don't see the point of this patch. It's just a string. Use the same
> > name and add a comment saying that on datasheet/TRM/documentation the
> > name LDO is actually referred to as LDOUSB. It's the same functionality
> > anyway.
> > 
> 
> I think for the avoidance of any doubt, it's probably best to use the
> TWL6025 string name here as it will importantly match the TWL6025 TRM
> and any schematics using the TWL6025. Getting this wrong during TWL6025
> board integration has the potential for hardware damage.

I would rather have something that doesn't depend on a correct string
and matches based on the device pointer instead. I agree that having the
correct string makes it easier to reference schematics/trm and the like,
but making the SW depend on the correct spelling of a simple string, is
too much for me :-(

Specially when getting it wrong "has the potential for hardware damage"
:-)

-- 
balbi
