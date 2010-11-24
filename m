Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0KXI4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:56:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44965 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0KXI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:56:50 -0500
Date: Wed, 24 Nov 2010 09:56:45 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/6] add some KERN_CONT markers to continuation lines
Message-ID: <20101124085645.GW4693@pengutronix.de>
References: <20101011152516.GF27153@n2100.arm.linux.org.uk> <1290505382-16110-1-git-send-email-u.kleine-koenig@pengutronix.de> <20101123101210.GA18170@n2100.arm.linux.org.uk> <20101123103940.GN4693@pengutronix.de> <20101123105830.GO4693@pengutronix.de> <AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com> <20101124081748.GV4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101124081748.GV4693@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I wonder why you implemented "iff there is a log-level marker at the
> beginning ot the string (with KERN_CONT being the exception)." and not
> "unless there is a KERN_CONT marker".
While playing around with the latter variant some outputs broke (as
expected).

I don't know if we ever switch to do that, still make the continuation
lines explicit by adding the KERN_CONT marker.  These appeared when
booting am ARM/imx machine, there are probably more ...

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
