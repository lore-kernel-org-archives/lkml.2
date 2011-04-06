Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1DFLGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:06:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60201 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1DFLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:06:30 -0400
Date: Wed, 6 Apr 2011 13:06:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 5/5] driver core: let dev_set_drvdata return int
 instead of void as it can fail
Message-ID: <20110406110623.GC13963@pengutronix.de>
References: <20110301153438.GB15633@suse.de>
 <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <BANLkTikVpacjh1EsQQoaQRN3j-kxxjr7qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikVpacjh1EsQQoaQRN3j-kxxjr7qA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 06, 2011 at 11:36:46AM +0200, Michał Mirosław wrote:
> 2011/4/6 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >
> > I wasn't sure what to return when dev_set_drvdata is called with
> > dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
> > think?
> 
> Why not just BUG_ON(!dev)? Is there a case when you might call this
> with dev==NULL that's not a driver bug?
I think BUG_ON is too harsh. Will resend with -EINVAL.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
