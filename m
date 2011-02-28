Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1B1PuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:50:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1B1PuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:50:15 -0500
Date: Mon, 28 Feb 2011 16:50:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel@pengutronix.de, Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] tty/vt: add some KERN_CONT markers to continuation
 lines
Message-ID: <20110228155008.GQ22310@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
 <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110228151641.GN22310@pengutronix.de>
 <20110228153946.GA26719@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110228153946.GA26719@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Mon, Feb 28, 2011 at 07:39:46AM -0800, Greg KH wrote:
> On Mon, Feb 28, 2011 at 04:16:41PM +0100, Uwe Kleine-König wrote:
> > Hello Greg,
> > 
> > should this patch go via your tree?
> 
> Yes, care to resend it in a format I can apply it in?
I bounced you the original mail assuming this is enough.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
