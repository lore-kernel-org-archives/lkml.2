Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2BCGps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:45:48 -0500
Received: from imr4.ericy.com ([198.24.6.9]:53877 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BCGpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:45:47 -0500
Date: Thu, 2 Feb 2012 22:43:59 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Aaron Sierra <asierra@xes-inc.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120203064359.GA25126@ericsson.com>
References: <1328220172.2261.162.camel@groeck-laptop>
 <484bd1ed-f456-40b5-b5c2-c0e50f2787d5@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <484bd1ed-f456-40b5-b5c2-c0e50f2787d5@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 06:25:14PM -0500, Aaron Sierra wrote:
> This driver currently creates resources for use by a forthcoming ICH
> chipset GPIO driver. It could be expanded to created the resources for
> converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> drivers to use the mfd model.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>

Hi Aaron,

I am having trouble applying your patch series. What is your baseline ?

Thanks,
Guenter

