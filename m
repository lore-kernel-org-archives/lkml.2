Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0JAHrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:47:39 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:54649 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0JAHri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:47:38 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 03:47:38 EDT
Date: Fri, 1 Oct 2010 09:38:36 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH 4/4] rtc/mc13xxx: add support for the rtc found in the
 MC13892 PMIC
Message-ID: <20101001093836.0109a3a8@linux.lan.towertech.it>
In-Reply-To: <1285777427-2887-4-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de>
	<1285777427-2887-4-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 18:23:47 +0200
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> The mfd driver for MC13783 recently got support for MC13892 and was
> renamed accordingly from mc13783-core to mc13xxx-core.  Do the same for
> rtc-mc13783.
> 
> The only relevant change is to use platform id's to tell the platform bus
> that this driver is responsible for mc13892-rtc devices, too.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

