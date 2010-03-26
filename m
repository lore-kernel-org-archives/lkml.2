Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0CZIAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 04:00:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0CZIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 04:00:18 -0400
Date: Fri, 26 Mar 2010 09:00:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: miguel.ojeda.sandonis@gmail.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] auxdisplay: section cleanup in cfag12864bfb driver
Message-ID: <20100326080015.GA20553@pengutronix.de>
References: <1269566774-26330-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269566774-26330-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:26:14AM +0100, Henrik Kretzschmar wrote:
> This fixes a two section mismatches and makes
> remove() __devexit.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Looks good,

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
