Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab0HDUOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:14:07 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:17310 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934488Ab0HDUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:13:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF5nWUxQycd2/2dsb2JhbACgJ3LFVQ2CZoJIBA
Date: Wed, 4 Aug 2010 22:13:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: dann frazier <dannf@hp.com>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 09/15] Despecificate driver from iLO2
Message-ID: <20100804201341.GC30740@infomag.iguana.be>
References: <1280274663-9160-1-git-send-email-dannf@hp.com> <1280274663-9160-10-git-send-email-dannf@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280274663-9160-10-git-send-email-dannf@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> This driver supports both iLO2 and iLO3, but our user-visible strings
> currently only reference iLO2. Let's just call it "iLO" to avoid having
> to update strings for each iLO generation. This driver doesn't support
> iLO ASICs prior to iLO2, but that is sufficiently explained in Kconfig.

Just a thought: Wouldn't it be more consistent if it's called iLO2+ everywhere?

> -	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
> +	tristate "HP Proliant iLO Hardware Watchdog Timer"

would be: tristate "HP Proliant iLO2+ Hardware Watchdog Timer"

> -	.identity = "HP iLO2 HW Watchdog Timer",
> +	.identity = "HP iLO HW Watchdog Timer",

and: .identity = "HP iLO2+ HW Watchdog Timer",

> -	 * First let's find out if we are on an iLO2 server. We will
> +	 * First let's find out if we are on an iLO2+ server. We will

> -		dev_warn(&dev->dev,
> -			"This server does not have an iLO2 ASIC.\n");
> +		dev_warn(&dev->dev, "This server does not have an iLO ASIC"
> +			 " version 2 or greater.\n");

dev_warn(&dev->dev,
	"This server does not have an iLO2+ ASIC.\n");

> -			"Unable to detect the iLO2 server memory.\n");
> +			"Unable to detect the iLO server memory.\n");

"Unable to detect the iLO2+ server memory.\n");

For the rest I'm still reviewing the code.

Kind regards,
Wim.

