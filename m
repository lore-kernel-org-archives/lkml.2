Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0HDM1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:27:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43612 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab0HDM1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:27:01 -0400
Date: Wed, 4 Aug 2010 14:26:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section Mismatches
Message-ID: <20100804122659.GA13814@pengutronix.de>
References: <20100804111156.GD19377@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100804111156.GD19377@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Aug 04, 2010 at 02:11:56PM +0300, Felipe Balbi wrote:
> I see that your commit 0db252452378aa7a9e001a13226e1cd1dc61453d removed  
> the *_driver from the symbol whitelist when referencing init section  
> (heh, it took a while), but could you explain what's the rationale  
> behind that ?
The rational is that it's AFAIK wrong if a driver references a function
that lives in .init.text.

Do you think that's wrong?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
