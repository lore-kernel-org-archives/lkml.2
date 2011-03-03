Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab1CCLCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:02:33 -0500
Received: from www.tglx.de ([62.245.132.106]:44065 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1CCLCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:02:32 -0500
Date: Thu, 3 Mar 2011 12:02:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
In-Reply-To: <20110303093532.GO22310@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1103031140330.2701@localhost6.localdomain6>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com> <20110302215238.GK22310@pengutronix.de> <alpine.LFD.2.00.1103022343410.2701@localhost6.localdomain6> <20110303093532.GO22310@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-151681322-1299150136=:2701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-151681322-1299150136=:2701
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 3 Mar 2011, Uwe Kleine-König wrote:
> On Thu, Mar 03, 2011 at 12:51:32AM +0100, Thomas Gleixner wrote:
> > > > +static int __init mx5_pm_init(void)
> > > I'd prefer to have that called by imx51_init_early.
> > 
> > And the reason is? 
> > 
> >     1) your personal preference
> >     2) there is some useful technical reason
> > 
> > If #1, then this comment was just waste of electrons
> > If #2, you failed to provide some reasonable explanation
> Actually it's #2, and to quote a different review[1]:
> 
> 	Reviewers hint to a correct solution and you are supposed to
> 	lookup what that solution means and act accordingly. If you do
> 	not understand the hint or its implications please ask [...]

I said the above when I hinted to use DEFINE_SPINLOCK(lock) instead of
static spinlock_t lock. And that requires to lookup what
DEFINE_SPINLOCK() actually does, which is a reasonable request.

How is the author of that code supposed to figure out what the merit
of s/mx5_pm_init/imx51_init_early/ is? By looking up your preferences
in google or what?

Using random quotes and failing to see why they don't apply is just
another proof of my assumption #1

Thanks,

	tglx


---1463795968-151681322-1299150136=:2701--
