Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab1IOPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:09:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:29865 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933892Ab1IOPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:09:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,387,1312182000"; 
   d="scan'208";a="53996225"
Date: Thu, 15 Sep 2011 17:12:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: linux-arm-kernel@lists.infradead.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, David Jander <david@protonic.nl>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        kernel@pengutronix.de, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110915151213.GE32263@sortiz-mobl>
References: <20110824132740.GA28197@pengutronix.de>
 <201108250905.13168.philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108250905.13168.philippe.retornaz@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Thu, Aug 25, 2011 at 09:05:12AM +0200, Philippe Rétornaz wrote:
> Le mercredi 24 août 2011 15:27:40, Uwe Kleine-König a écrit :
> > Hello,
> > 
> > this series removes the long obsolte mc13783 API after fixing all
> > remaining users.
> 
> I posted a patch last month which was touching this MFD too.
> We will need to synchronize both patch. 
I applied Uwe's patchset now. Could you please sync your code and send me a
patchset that applies on top of:

git://git.infradead.org/users/sameo/mfd-2.6.git for-next

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
