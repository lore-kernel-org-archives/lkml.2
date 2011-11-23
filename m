Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1KWL4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:56:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56886 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1KWLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:55:59 -0500
Date: Wed, 23 Nov 2011 12:55:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <C.Emde@osadl.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>, kernel@pengutronix.de
Subject: Re: [ANNOUNCE] 3.0.10-rt27
Message-ID: <20111123115555.GN19986@pengutronix.de>
References: <1322010805.20742.40.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322010805.20742.40.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 22, 2011 at 08:13:25PM -0500, Steven Rostedt wrote:
> I'm please to announce the 3.0.10-rt27 stable release.
As Debian unstable already switched to 3.1 I provided this release on a
Pengutronix server.

If you want it, you can just add

	deb http://debian.pengutronix.de/debian sid main

to your apt's sources list and after an list update install

	linux-image-3.0.0-2-rt-amd64

(and pengutronix-archive-keyring if you're embarrassed by the warnings
about untrusted sources).

Alternatively just download

	http://debian.pengutronix.de/debian/pool/main/l/linux-2.6/linux-image-3.0.0-2-rt-amd64_3.0.0-6ptx3_amd64.deb

and install it using dpkg.

Version 3.0.0-6ptx3 includes 3.0.10-rt27 (well in fact it's 3.0.9-rt26 +
3.0.10, but the result is the same).

It should integrate well with a squeeze system, but note that I only
tested it lightly. If you have any problems or suggestions free to
report them to me via this list.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
