Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1DTHm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:42:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57973 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1DTHm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:42:58 -0400
Date: Wed, 20 Apr 2011 09:42:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Subject: Re: [PATCH v2] driver core: let dev_set_drvdata return int instead
 of void as it can fail
Message-ID: <20110420074248.GS31131@pengutronix.de>
References: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
 <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110419235812.GA4619@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110419235812.GA4619@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 04:58:12PM -0700, Greg KH wrote:
> On Mon, Apr 11, 2011 at 08:42:58PM +0200, Uwe Kleine-König wrote:
> > Before commit
> > 
> > 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> > 
> > calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> > discussion about what to return in this case removing the check (and so
> > producing a null pointer exception) seems fine.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > @Viresh: as I didn't choose to return -EINVAL I didn't add your Reviewed-by:
> 
> I'm confused by this thread, care to resend all of these in a series
> against the latest linux-next tree?
No problem, here it comes. This are patches 1 to 4 of the original
series + v2 of patch 5 (that didn't have 5/5 in the subject).

Best regards,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
