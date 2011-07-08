Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1GHSEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:04:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57738 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1GHSD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:03:59 -0400
Subject: Re: [PATCH 2/2] regulator: Add a new regulator for charge control
 of MAX8998/LP3974
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <20110708131655.GB32754@oksana.dev.rtsoft.ru>
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
	 <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
	 <20110708131655.GB32754@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 19:03:54 +0100
Message-ID: <1310148234.3348.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 17:16 +0400, Anton Vorontsov wrote:
> On Fri, Jun 24, 2011 at 07:04:19PM +0900, Donggeun Kim wrote:
> > With the new regulator, "CHARGER", users can control charging current and
> > turn on and off the charger.
> > Note that the charger specification of LP3974 is different from
> > that of MAX8998.
> > 
> > Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> > ---
> 
> Liam, Mark,
> 
> Can I take it via battery-2.6.git tree?
> 

Yes, I don't see 1/2 so I assume its battery related and easier to merge
in your tree ?

Liam


