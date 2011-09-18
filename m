Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1IRQbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 12:31:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:36403 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1IRQbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 12:31:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="49800312"
Date: Sun, 18 Sep 2011 18:33:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-arm-kernel@lists.infradead.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, David Jander <david@protonic.nl>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        kernel@pengutronix.de, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110918163351.GL32263@sortiz-mobl>
References: <20110824132740.GA28197@pengutronix.de>
 <201108250905.13168.philippe.retornaz@epfl.ch>
 <20110915151213.GE32263@sortiz-mobl>
 <20110915160321.GA29357@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110915160321.GA29357@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Sep 15, 2011 at 06:03:21PM +0200, Uwe Kleine-König wrote:
> Hi Samuel,
> 
> On Thu, Sep 15, 2011 at 05:12:13PM +0200, Samuel Ortiz wrote:
> > On Thu, Aug 25, 2011 at 09:05:12AM +0200, Philippe Rétornaz wrote:
> > > Le mercredi 24 août 2011 15:27:40, Uwe Kleine-König a écrit :
> > > > Hello,
> > > > 
> > > > this series removes the long obsolte mc13783 API after fixing all
> > > > remaining users.
> > > 
> > > I posted a patch last month which was touching this MFD too.
> > > We will need to synchronize both patch. 
> > I applied Uwe's patchset now.
> Thanks.
> 
> >                               Could you please sync your code and send me a
> > patchset that applies on top of:
> > 
> > git://git.infradead.org/users/sameo/mfd-2.6.git for-next
> You can fetch the updated series from
> 
> 	git://git.pengutronix.de/git/ukl/linux-2.6.git mc13783
I merged this one on top of my for-next branch. My MFD tree temporary lives on
infradead:

git://git.infradead.org/users/sameo/mfd-2.6.git

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
