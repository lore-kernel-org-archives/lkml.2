Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1K1Suy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:50:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60365 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1K1Sux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:50:53 -0500
Date: Mon, 28 Nov 2011 19:52:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-pm@vger.kernel.org,
        len.brown@intel.com, rjw@sisk.pl, rdunlap@xenotime.net,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Philip Rakity <prakity@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC PATCH 1/2] power: Charger-Manager: add initial
 Charger-Manager driver
Message-ID: <20111128185201.GA11612@elf.ucw.cz>
References: <1321524793-25117-1-git-send-email-dg77.kim@samsung.com>
 <1321524793-25117-2-git-send-email-dg77.kim@samsung.com>
 <20111126010613.GA591@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126010613.GA591@oksana.dev.rtsoft.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-11-26 05:06:13, Anton Vorontsov wrote:
> On Thu, Nov 17, 2011 at 07:13:12PM +0900, Donggeun Kim wrote:
> > Because battery health monitoring should be done even when suspended,
> > it needs to wake up and suspend periodically. Thus, userspace battery
> > monitoring may incur too much overhead; every device and task is woken
> > up periodically. Charger Manager uses suspend-again to provide
> > in-suspend monitoring.
> > 
> > This patch allows to monitor battery health in-suspend state.
> > 
> > Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> 
> I very much appreciate this effort, it discourages proprietary
> charger-managers (e.g. infamous "BME" on Nokia N900).

It will also allow us to replace hand-coded charger manager for Sharp
SL-3000 (and similar) machines. Good.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
