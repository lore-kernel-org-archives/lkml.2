Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1IVXie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:38:34 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:54343 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1IVXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:38:32 -0400
Date: Thu, 22 Sep 2011 17:38:31 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 0/2] arm: omap: usb: enable I/O wakeups of ehci and ohci
 hwmods
In-Reply-To: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1109221737210.10719@utopia.booyaka.com>
References: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

so as 

   http://marc.info/?l=linux-omap&m=131673433121673&w=2

mentions, these should either be associated with the UHH IP block, or 
handled by code in arch/arm/mach-omap2/usb-host.c, since the EHCI and OHCI 
IP blocks are created by the OMAP USB host MFD driver.


- Paul
