Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1F1KH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:07:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1F1KEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:04:54 -0400
Date: Tue, 28 Jun 2011 12:04:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: viresh kumar <viresh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
Message-ID: <20110628100438.GI6069@pengutronix.de>
References: <cover.1306831238.git.viresh.kumar@st.com>
 <4E086590.8080100@st.com>
 <201106271526.12848.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106271526.12848.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:03:03 up 6 days, 15:50, 41 users,  load average: 0.09, 0.17, 0.38
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 03:26:12PM +0200, Arnd Bergmann wrote:
> On Monday 27 June 2011, viresh kumar wrote:
> > On 05/31/2011 02:21 PM, Viresh KUMAR wrote:
> > > This patchset adds drivers/pwm directory as suggested by Arnd Bergmann in
> > > following discussion:
> > > 
> > > http://comments.gmane.org/gmane.linux.ports.arm.kernel/118651
> > > 
> > > and also adds support for ST Microelectronics Pulse Width Modulator. This is
> > > currently used by ST's SPEAr platform and tested on the same.
> > > 
> > > Changes since V1:
> > >  - Moved driver to drivers/pwm/ directory from drivers/misc
> > >  - arch/arm/configs/spear3xx_defconfig updated accordingly.
> > > 
> > > Changes since earlier patchset:
> > >  - Moved driver to drivers/misc/ directory.
> > > 
> > > It was earlier reviewed as part of following patchset:
> > > "[PATCH V6 00/17] Adding devices support for all spear machines"
> > > 
> > > Viresh Kumar (3):
> > >   drivers/pwm st_pwm: Add support for ST's Pulse Width Modulator
> > >   SPEAr3xx: Add machine support for ST's PWM IP
> > >   SPEAr3xx: Update defconfig for ST's PWM
> >
> > Will you push this patchset through your tree or somebody else will do?
> 
> Good question. If Sascha is able to come up with the patch to introduce
> the generic layer, I think it would be good to have it go though him.

Just posted a rebased and documented series again. Let's see what
happens. The time seems good to finally get this into the kernel.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
