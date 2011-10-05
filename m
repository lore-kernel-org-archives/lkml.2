Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab1JEHCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:02:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60874 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253Ab1JEHCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:02:19 -0400
X-Greylist: delayed 114785 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Oct 2011 03:02:19 EDT
X-Sasl-enc: F274N29dMll+m1kYT+eY0GsJiNl+fdAEtTmjrQje+IoF 1317798138
Date: Tue, 4 Oct 2011 23:56:17 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Message-ID: <20111005065617.GA6824@kroah.com>
References: <20111004232403.10364.22050.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
> For simple modules that contain a single platform_driver without any
> additional setup code then ends up being a block of duplicated
> boilerplate.  This patch adds a new macro, module_platform_driver(),
> which replaces the module_init()/module_exit() registrations with
> template functions.
> 
> This patch also converts all the relevant spi drivers to use the new
> macro.  There are a lot of drivers in the tree that are using this
> pattern and could be converted.
> 
> It also fixes up some incorrect section annotations where I found
> them.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> I think this is useful, and I like the diffstat that it produces.
> What does everyone else think of this approach?  I can do versions for
> i2c_drivers and spi_drivers too.
> 
> This is *not* tested very much.  I'm circulating mostly for review for
> now.

The idea looks sane to me, I like the diffstat it ends up creating, nice
job.

greg k-h
