Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1IVXfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:35:23 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:54315 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1IVXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:35:22 -0400
Date: Thu, 22 Sep 2011 17:35:21 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1109221732140.10719@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava

so based on a closer look at how the EHCI/OHCI IP blocks are actually 
implemented on OMAP, they should not have hwmod entries associated with 
them.  Please take a look at 

http://marc.info/?l=linux-omap&m=131673433121673&w=2


- Paul
