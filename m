Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2EFLuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 07:50:35 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:65272 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2EFLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 07:50:34 -0400
Date: Sun, 6 May 2012 04:49:10 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb347_charger: cleaned battery power supply attributes
Message-ID: <20120506114909.GA457@lizard>
References: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120506111412.GG31494@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120506111412.GG31494@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 02:14:12PM +0300, Mika Westerberg wrote:
> On Sat, May 05, 2012 at 09:33:54PM +0530, Ramakrishna Pallala wrote:
> > CURRENT_NOW and VOLTAGE_NOW should be instantaneous readings
> > from power supply(ex: battery).
> > 
> > smb347 charger driver reports charge voltage for VOLTAGE_NOW
> > and charge current for CURRENT_NOW attributes which are not
> > instantaneous readings.
> > 
> > This patch removes the battery VOLTAGE_NOW and CURRENT_NOW
> > properties from the driver and also removes hw_to_current()
> > which is not required anymore.
> > 
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> 
> I agree. As the chip only reports voltage and current what is configured
> (and not the actual values) these attributes are pretty much useless and I
> should've never introduced them in the first place. A separate Fuel Gauge
> or similar is right place to get the actual values.
> 
> As long as Anton is ok with this, you can add my
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
