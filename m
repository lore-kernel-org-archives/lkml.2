Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1HYHL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:11:57 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:43772 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753022Ab1HYHL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:11:56 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 03:11:55 EDT
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] mc13783 cleanup
Date: Thu, 25 Aug 2011 09:05:12 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.40.3-0.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, David Jander <david@protonic.nl>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        kernel@pengutronix.de, linux-input@vger.kernel.org
References: <20110824132740.GA28197@pengutronix.de>
In-Reply-To: <20110824132740.GA28197@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108250905.13168.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 août 2011 15:27:40, Uwe Kleine-König a écrit :
> Hello,
> 
> this series removes the long obsolte mc13783 API after fixing all
> remaining users.

I posted a patch last month which was touching this MFD too.
We will need to synchronize both patch. 

BTW, Sascha, could you give your ack/nack on my patch (mc13783: add pwr button 
support) ? it has been a month without any news from your side. Thanks ! 

Regards,

Philippe

