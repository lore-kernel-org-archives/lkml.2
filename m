Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1AEIkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:40:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36628 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AEIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:40:24 -0500
Date: Wed, 5 Jan 2011 09:40:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
Message-ID: <20110105084014.GN25121@pengutronix.de>
References: <20101230171453.GA5787@pengutronix.de> <1293731992.4919.5.camel@heimdal.trondhjem.org> <20101230191846.GB14221@pengutronix.de> <20110103213850.GC25121@pengutronix.de> <1294100558.25100.8.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1294100558.25100.8.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Trond,

On Mon, Jan 03, 2011 at 07:22:38PM -0500, Trond Myklebust wrote:
> The question is whether this is something happening on the server or the
> client. Does an older client kernel boot without any trouble?
I will set up a boot test with 2.6.37 (for statistics) and 2.6.36 to
compare with.  If you don't consider .36 to be old enough let me now.
Once the setup is done it should be easy to test .35 (say), too.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
