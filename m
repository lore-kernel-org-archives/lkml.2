Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1FITJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:09:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36932 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753574Ab1FITJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:09:28 -0400
Date: Thu, 9 Jun 2011 20:09:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: Add rdev_crit() macro
Message-ID: <20110609190925.GD2821@opensource.wolfsonmicro.com>
References: <1307631997-32061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1307644635.13329.36.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307644635.13329.36.camel@Joe-Laptop>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:37:15AM -0700, Joe Perches wrote:

> > +#define rdev_crit(rdev, fmt, ...)					\
> > +	pr_crit("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)

> If that's really necessary, shouldn't rdev_emerg, rdev_alert
> and rdev_notice be added as well?

Yes, but I don't habitually use those when adding random trace during
debug so don't care myself.
