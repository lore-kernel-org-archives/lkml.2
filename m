Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GIAUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:20:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44803 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751811Ab1GIAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:20:04 -0400
Date: Sat, 9 Jul 2011 09:19:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Add a new regulator for charge control of
 MAX8998/LP3974
Message-ID: <20110709001945.GB18860@opensource.wolfsonmicro.com>
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
 <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
 <20110708131655.GB32754@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708131655.GB32754@oksana.dev.rtsoft.ru>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 05:16:55PM +0400, Anton Vorontsov wrote:
> On Fri, Jun 24, 2011 at 07:04:19PM +0900, Donggeun Kim wrote:

> > With the new regulator, "CHARGER", users can control charging current and
> > turn on and off the charger.
> > Note that the charger specification of LP3974 is different from
> > that of MAX8998.

> Can I take it via battery-2.6.git tree?

I'm still not entirely comfortable with the whole concept of
implementing this as a generic charger driver.  It seems like these
regulators are heavily integrated into the PMU part of the device rather
than being general purpose devices.
