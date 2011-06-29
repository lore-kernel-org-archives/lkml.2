Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1F2JOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:14:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43629 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1F2JOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:14:45 -0400
Date: Wed, 29 Jun 2011 11:14:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
Message-ID: <20110629091441.GA9349@pengutronix.de>
References: <cover.1306831238.git.viresh.kumar@st.com>
 <201106271526.12848.arnd@arndb.de>
 <20110628100438.GI6069@pengutronix.de>
 <201106281713.16099.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106281713.16099.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:40 up 7 days, 14:55, 32 users,  load average: 0.44, 0.66, 1.99
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 05:13:15PM +0200, Arnd Bergmann wrote:
> On Tuesday 28 June 2011, Sascha Hauer wrote:
> > > 
> > > Good question. If Sascha is able to come up with the patch to introduce
> > > the generic layer, I think it would be good to have it go though him.
> > 
> > Just posted a rebased and documented series again. Let's see what
> > happens. The time seems good to finally get this into the kernel.
> 
> I'd say let's go forward with your framework. The two patches currently
> because they both add Makefile/Kconfig files in drivers/pwm.
> 
> Maybe you can add Viresh's patch to your series, and wait for him
> to follow up with a patch to convert it?
> 
> I've tried to blindly do the conversion myself, but got stuck with the
> definition of the platform device that has multiple pwms in it.
> I wonder if it would be better to change the st-pwm platform
> interface to define one platform_device for each of them.

Definitely. From a quick look at the driver it seems the pwms all have
a seperate register space.

I can add Viresh's patch to my series once we agree on the base patch.
In the meantime maybe Viresh starts converting it ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
