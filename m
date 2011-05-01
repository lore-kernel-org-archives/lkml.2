Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab1EAPog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:44:36 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38477 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1EAPof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:44:35 -0400
Date: Sun, 1 May 2011 08:43:44 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: twl4030-madc-hwmon: Return proper error if
 hwmon_device_register fails
Message-ID: <20110501154344.GA21906@ericsson.com>
References: <1304264095.2327.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1304264095.2327.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 11:34:55AM -0400, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good catch. Applied.

Thanks,
Guenter
