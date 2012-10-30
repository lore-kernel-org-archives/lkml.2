Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2J3JkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:40:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56037 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab2J3JkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:40:07 -0400
Date: Tue, 30 Oct 2012 10:40:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: Milan Broz <gmazyland@gmail.com>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, okozina@redhat.com,
        linux-rt-users@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - RT patch set seem
 to break it
Message-ID: <20121030094001.GV639@pengutronix.de>
References: <5083C61C.5090807@gmail.com>
 <5083E4A8.3060501@ursulin.net>
 <5083E87B.2080908@gmail.com>
 <5083EC61.8070505@ursulin.net>
 <50844D01.9090805@gmail.com>
 <5084551E.5040304@ursulin.net>
 <508ED985.5060301@ursulin.net>
 <508EDD6E.7030908@gmail.com>
 <508EE395.9010709@ursulin.net>
 <508EEAF2.4090506@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <508EEAF2.4090506@ursulin.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 08:45:38PM +0000, Tvrtko Ursulin wrote:
> On 29/10/12 20:14, Tvrtko Ursulin wrote:
> >On 29/10/12 19:47, Milan Broz wrote:
> >>On 10/29/2012 08:31 PM, Tvrtko Ursulin wrote:
> >>>Just tried 3.6.4 and it is still broken. Is there anything else I could
> >>>try to debug this?
> >>
> >>See response from response from Ondra on dmcrypt list - your kernel
> >>config
> >>is perhaps broken.
> >
> >I don't think that reached me - perhaps I was not copied.
> >
> >Weird yes, I mean no one can spot anything bad with my config...
> >
> >>Please use fresh checkout, run make oldconfig and try again.
> >>(Many people use 3.6 already and there is no other report.)
> >
> >... and I just used it today to configure a fresh 3.6.4 (plus -rt10
> >patches) without a problem.
> >
> >Unless RT patchset is the culprit. Hm.. that would be unexpected, but I
> >guess it is worth a shot. I'll let you know what happens without -rt.
> 
> Ha, this is exciting, vanilla 3.6.4 works, with -rt10 patch it does not.
I experienced that problem, too. This is on a laptop with encrypted
rootfs, so debugging is a bit harder here. I am just setting up another
machine to debug that.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
