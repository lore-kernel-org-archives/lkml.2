Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0FOJFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:05:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51977 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0FOJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:05:07 -0400
Date: Tue, 15 Jun 2010 11:05:00 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dtor@mail.ru>, Eric Miao <eric.y.miao@gmail.com>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] Driver core: reduce duplicated code
Message-ID: <20100615090500.GA17595@pengutronix.de>
References: <1276591677-4678-1-git-send-email-u.kleine-koenig@pengutronix.de> <1276591677-4678-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276591677-4678-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 15, 2010 at 10:47:56AM +0200, Uwe Kleine-König wrote:
> This makes the two similar functions platform_device_register_simple
> and platform_device_register_data one line inline functions using a new
> generic function platform_device_register_resndata.
I forgot to add some comments to this mail, ... sorry.

 - I'm not completely happy with the name of the new function.  If
   someone has a better name please tell me.
 - can platform_device_register_resndata be moved to __init_or_module?
 - I moved the kernel docs to the header but didn't test if they are
   picked up when generating docs.  Even if not, there is no better
   place, is there?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
