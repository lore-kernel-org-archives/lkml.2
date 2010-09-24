Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0IXPSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:18:52 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53215 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab0IXPSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:18:51 -0400
Date: Fri, 24 Sep 2010 08:17:59 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jean Delvare <khali@linux-fr.org>, Takashi Iwai <tiwai@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
Message-ID: <20100924151759.GC18153@ericsson.com>
References: <s5heiclngqe.wl%tiwai@suse.de>
 <20100924135802.GA18109@ericsson.com>
 <s5hlj6r1b5p.wl%tiwai@suse.de>
 <20100924163005.7704f63e@endymion.delvare>
 <4C9CBF4E.7080200@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C9CBF4E.7080200@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 11:10:06AM -0400, Jonathan Cameron wrote:
[...]
> Technically hwmon is orphan (according to MAINTAINERS.) But that's not to

If you pull the latest tree, you'll notice that this is no longer correct.

Thanks,
Guenter

