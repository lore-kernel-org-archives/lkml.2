Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1DFGvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:51:37 -0400
Received: from imr4.ericy.com ([198.24.6.8]:53371 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1DFGvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:51:35 -0400
Date: Tue, 5 Apr 2011 23:50:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "achew@nvidia.com" <achew@nvidia.com>
CC: "wni@nvidia.com" <wni@nvidia.com>,
        "w30289@motorola.com" <w30289@motorola.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "olofj@chromium.org" <olofj@chromium.org>,
        "toddpoynor@google.com" <toddpoynor@google.com>
Subject: Re: [lm-sensors] [PATCH 1/1] [hwmon] nct1008: Initial NCT1008
 driver
Message-ID: <20110406065048.GA23290@ericsson.com>
References: <1302059183-29631-1-git-send-email-achew@nvidia.com>
 <20110406050929.GA22741@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110406050929.GA22741@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 01:09:29AM -0400, Guenter Roeck wrote:
> On Tue, Apr 05, 2011 at 11:06:23PM -0400, achew@nvidia.com wrote:
> > From: Andrew Chew <achew@nvidia.com>
> >
> > This is a digital temperature sensor I2C peripheral from ON Semiconductor.
> >
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> 
> Comments inline. Note that this is not a complete review.
> 
Actually, turns out it would be much simpler to add support for this chip
to the lm90 driver. It is pretty much identical to ADT7461. Even more
interesting is that the chip ID is identical to the ADT7461A chip ID.

Guenter
