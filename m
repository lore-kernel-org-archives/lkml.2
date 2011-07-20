Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1GTKdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:33:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33722 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751229Ab1GTKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:33:17 -0400
Date: Wed, 20 Jul 2011 11:33:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
Message-ID: <20110720103312.GA30059@opensource.wolfsonmicro.com>
References: <20110718100444.GD423@opensource.wolfsonmicro.com>
 <1310983663-6404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310983663-6404-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110719215120.GS6848@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719215120.GS6848@ponder.secretlab.ca>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 03:51:20PM -0600, Grant Likely wrote:

> regmap_init_i2c/spi should take an i2c_client and spi_device pointer
> respectively so it can be type checked.

Bah, you're right.  That was me trying to do the update far too quickly.
Fixed now, thanks for spotting.  Though I still don't find this
interface so pleasant to use with the multi-bus devices.
