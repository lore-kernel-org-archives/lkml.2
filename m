Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1IPHQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:16:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1IPHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:16:43 -0400
Date: Fri, 16 Sep 2011 09:16:38 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20110916071638.GJ11297@pengutronix.de>
References: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Fri, Sep 16, 2011 at 01:55:23PM +1000, Stephen Rothwell wrote:
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/leds/leds-mc13783.c: In function 'mc13783_leds_prepare':
> drivers/leds/leds-mc13783.c:193:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:196:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:203:14: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:206:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:213:14: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:216:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:223:14: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:226:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:233:14: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:236:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:244:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:246:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:248:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:250:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:253:15: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:255:15: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c: In function 'mc13783_led_probe':
> drivers/leds/leds-mc13783.c:278:11: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:278:34: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:279:54: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:283:36: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:295:23: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:297:19: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:299:14: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:299:47: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:300:50: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:305:31: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:307:13: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:312:27: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:313:31: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:314:42: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:317:24: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c:329:43: error: dereferencing pointer to incomplete type
> drivers/leds/leds-mc13783.c: In function 'mc13783_led_remove':
> drivers/leds/leds-mc13783.c:359:23: error: dereferencing pointer to incomplete type
> 
> Presumably caused by commit 747c98a3660d ("leds: Convert mc13783 driver
> to mc13xxx MFD").
> 
> I have used the mfd tree from next-20110915 for today.
I'd look into the issue, but I don't have 747c98a3660d and I don't know
where to get it from. IMHO it would be great if you could push your next
tree somewhere.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
