Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1BRJ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:58:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60090 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1BRJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:58:11 -0500
Date: Fri, 18 Feb 2011 10:58:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <srostedt@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] gpio: add trace events for setting direction and value
Message-ID: <20110218095803.GY22310@pengutronix.de>
References: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1297876371.26768.7235.camel@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297876371.26768.7235.camel@fedora>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven, hi Grant,

On Wed, Feb 16, 2011 at 12:12:51PM -0500, Steven Rostedt wrote:
> Note: to save the memory footprint of these tracepoints, you can use
> DEFINE_EVENT_PRINT(). You can see the usage for this in the
> include/trace/events/kmem.h.
> But to do this, you will need to have a single TP_STRUCT__entry() for
> both. Not sure if this is what you want.
> 
> 	TP_STRUCT__entry(
> 		__field(unsigned, gpiq)
> 		__field(int, get_in)
> 		__field(int, value_err)
> 
> ??
> 
> Just a suggestion, but may not be worth it.
Yeah, I saw that, still I think it's sane to keep them seperated.
Or how much would we save?  Can you estimate that?

@Grant: Steven told me this should go via your tree, so if you are OK
with the change, feel free to take it.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
