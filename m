Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2DEGxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:53:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3476 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2DEGxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:53:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6670"; a="176769491"
Message-ID: <4F7D4165.2060101@codeaurora.org>
Date: Thu, 05 Apr 2012 12:23:25 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific
 macros in include/linux/power
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <1332173578-27422-3-git-send-email-j-pihet@ti.com> <4F7C9C89.9080605@codeaurora.org> <4F7CA3E1.2050809@ti.com>
In-Reply-To: <4F7CA3E1.2050809@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

>
> The main motivation is that it's a driver and thus does not have
> anything to do inside mach-omap2.

Right, I understood that. mach-omap2 is not suitable for full fledged 
drivers.

>
> Where will you put that otherwise?

Couple of suggestions:

drivers/platform/omap/avs?
drivers/misc/omap/avs?

I prefer first one.

>
> IIRC, David Brownell was referring to the rule of three for such case.
> Meaning that it worth having a generic fmwk when at least three
> different drivers are doing the same kind of things.

Yes, I remember that rule, but that's not stopping us to create a fwk, 
may be others will rise once they see the framework and contribute
if their h/w architecture requirements are not addressed?

---Trilok Soni

-- 
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
