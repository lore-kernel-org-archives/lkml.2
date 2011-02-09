Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1BISRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:17:55 -0500
Received: from imr4.ericy.com ([198.24.6.8]:52494 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab1BISRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:17:54 -0500
Date: Wed, 9 Feb 2011 10:17:02 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Dirk Eibach <eibach@gdsys.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] hwmon: Consider LM64 temperature offset
Message-ID: <20110209181702.GA19998@ericsson.com>
References: <20110208152815.GA13436@ericsson.com>
 <1297245094-13681-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1297245094-13681-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On Wed, Feb 09, 2011 at 04:51:34AM -0500, Dirk Eibach wrote:
[ ... ]
> +/* temp2_crit can only be set once which should be job of the bootloader */
> +static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO, show_remote_temp8,
> +	NULL, 2);

That only applies to lm63, though. It can be rewritten anytime on LM64.
That would be a separate patch, though, to not mix improvements with bug fixes.

Otherwise, looks good, so I'll apply it with an added remark that the restriction
only applies to lm63.

Thanks,
Guenter
