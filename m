Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0L3M0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 07:26:23 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:57979 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab0L3M0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 07:26:21 -0500
Date: Thu, 30 Dec 2010 14:26:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, Felipe Balbi <me@felipebalbi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
Message-ID: <20101230122615.GA3714@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
 <1293556459-28613-4-git-send-email-balbi@ti.com>
 <20101228235836.GA2609@opensource.wolfsonmicro.com>
 <1293583108.1822.3.camel@eowin>
 <20101229122808.GC2222@legolas.emea.dhcp.ti.com>
 <20101230121803.GA2667@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101230121803.GA2667@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 12:18:04PM +0000, Mark Brown wrote:
>On Wed, Dec 29, 2010 at 02:28:08PM +0200, Felipe Balbi wrote:
>
>> I believe you meant something like below, I'll get back to this in a
>> little while. Have lots to test:
>
>Yes, that looks like what I'd expect.

Good, I'll clean the patches up and wait past the merge window before
sending final versions.

-- 
balbi
