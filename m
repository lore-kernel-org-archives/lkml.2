Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2LSUfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:35:25 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39180 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2LSUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:35:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as children of master or not.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jun Chen <jun.d.chen@intel.com>
Cc: linux-kernel@vger.kernel.org, Bi Chao <chao.bi@intel.com>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <20121219090416.GK4985@opensource.wolfsonmicro.com>
References: <1355848174.1435.25.camel@chenjun-workstation> <20121218152623.GA26077@sirena.org.uk> <1355910243.1435.39.camel@chenjun-workstation> <20121219090416.GK4985@opensource.wolfsonmicro.com>
Date: Wed, 19 Dec 2012 16:21:42 +0000
Message-Id: <20121219162142.9E1123E0B72@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 09:04:16 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 19, 2012 at 04:44:03AM -0500, Jun Chen wrote:
> 
> > This spi_alloc_device function will be called in the spi_new_device
> > function to alloc new device as the master. But other way, it is called
> > by the of_register_spi_devices function to register new device as the
> > children of the master. I will update changlog to add it. 
> 
> But why is this a bad thing?  You've said what's happening but not why
> it's a problem.

spi_devices should always be children of the spi_master. If that is not
the case then it is a bug to be fixed.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
