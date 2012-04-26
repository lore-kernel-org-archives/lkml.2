Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2DZVey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:34:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34266 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2DZVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:34:53 -0400
Date: Thu, 26 Apr 2012 22:34:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: sameo@linux.intel.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/tps65910: fix section mismatch in linux-next
Message-ID: <20120426213449.GB9415@sirena.org.uk>
References: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 08:13:55AM -0700, Gerard Snitselaar wrote:

> -static int tps65910_i2c_probe(struct i2c_client *i2c,
> +static int __init tps65910_i2c_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)

I sent a separate fix for this earlier on - __init is the wrong
annotation here, a device init function should be marked __devinit.
