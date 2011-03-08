Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1CHBYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:24:16 -0500
Received: from imr3.ericy.com ([198.24.6.13]:60791 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1CHBYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:24:15 -0500
Date: Mon, 7 Mar 2011 17:23:23 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 3/3] hwmon: twl4030-madc-hwmon: add "platform:" prefix
 for platform modalias
Message-ID: <20110308012323.GC15345@ericsson.com>
References: <1299466949.3879.0.camel@mola>
 <1299467133.3879.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1299467133.3879.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 10:05:33PM -0500, Axel Lin wrote:
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
