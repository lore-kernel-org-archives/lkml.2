Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1EHPIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:08:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48458 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1EHPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:08:42 -0400
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: balbi@ti.com
Cc: Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com
In-Reply-To: <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
	 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
	 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 16:08:37 +0100
Message-ID: <1304867317.3246.10.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 13:45 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 27, 2011 at 10:39:51AM +0100, Graeme Gregory wrote:
> > The twl6025 uses a different regulator for USB than the 6030 so select
> > the correct regulator name depending on the subclass of device.
> > 
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> 
> I don't see the point of this patch. It's just a string. Use the same
> name and add a comment saying that on datasheet/TRM/documentation the
> name LDO is actually referred to as LDOUSB. It's the same functionality
> anyway.
> 

I think for the avoidance of any doubt, it's probably best to use the
TWL6025 string name here as it will importantly match the TWL6025 TRM
and any schematics using the TWL6025. Getting this wrong during TWL6025
board integration has the potential for hardware damage.

Liam

