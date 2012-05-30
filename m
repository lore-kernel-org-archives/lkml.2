Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2E3JjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:39:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45448 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2E3JjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:39:10 -0400
Message-ID: <4FC5F6EE.1020905@gmail.com>
Date: Wed, 30 May 2012 18:31:10 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Xiao Jiang <jgq516@gmail.com>
CC: "Cousson, Benoit" <b-cousson@ti.com>, linux@arm.linux.org.uk,
        linux-watchdog@vger.kernel.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, rnayak@ti.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, wim@iguana.be,
        Jon Hunter <jon-hunter@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] watchdog: omap_wdt: add device tree support
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-4-git-send-email-jgq516@gmail.com> <4FC51008.1050004@ti.com> <4FC59171.8040009@gmail.com> <4FC5D21F.2030702@ti.com> <4FC5F2FA.4050606@gmail.com>
In-Reply-To: <4FC5F2FA.4050606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> If there is no difference between the OMAP3 and the OMAP4 WDT IP, 
>> just add one entry "ti,omap3-wdt". And then in the OMAP4 DTS you will 
>> just put : compatible = "ti,omap3-wdt"; or compatible =  
>> "ti,omap4-wdt", "ti,omap3-wdt";
>> I'm still a little bit confused about the real need for the 
>> "ti,omap4-wdt: entry, but it seems to be the way to do it in PPC.
> I believe OMAP2, OMAP3 and OMAP4 share the same IP, so how about use 
> "ti, omap2-wdt"? and other dts files
> put compatible like "ti,omap4-wdt", "ti,omap2-wdt" and "ti,omap4-wdt", 
> "ti,omap2-wdt".
>
Typo, should be "ti,omap3-wdt", "ti,omap2-wdt" and "ti,omap4-wdt", 
"ti,omap2-wdt".

Regards,
Xiao
