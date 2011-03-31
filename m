Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1CaJYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:24:34 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:53582 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab1CaJYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:24:32 -0400
X-Greylist: delayed 2088 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 05:24:32 EDT
Subject: Re: [PATCH V2] Add the support of the touchscreen keypad of
 tsc2007 .
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: wanlong.gao@gmail.com, w.sang@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiaweiwei.xiyou@gmail.com
In-Reply-To: <20110331053324.GB31630@core.coreip.homeip.net>
References: <1301219192-5293-1-git-send-email-wanlong.gao@gmail.com>
	 <20110331053324.GB31630@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 09:49:04 +0100
Message-ID: <1301561344.24596.102.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 22:33 -0700, Dmitry Torokhov wrote:
> Hi Wanlong,
> 
> On Sun, Mar 27, 2011 at 05:46:32PM +0800, wanlong.gao@gmail.com wrote:
> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Many touchscreens support touch-keypad .
> > Open the definition of the TOUCHSCREEN_TSC2007_WITH_KEYPAD, you can
> > open the support of the touchscreen's keypad .
> > We can add the support of the touchscreen keypad in the driver.
> > In this patch , add the ts_key_pos array to determine the position
> > of the key's X. And the ts_key_sensitivity can use to detemine the
> > key's sensitivity. You can modify the ts_key_pos array for you own
> > touchscreen keys . And modify the ts_key_sensitivity for you own
> > key's sensitivity .
> > If you want to modify the ts_key_map, change the position of the
> > keys ,too.
> 
> No, this kind of data transformation does not belong to a driver (or,
> really in kernel). It is in no way TSC2007 specific (any touchscreen
> could be used in place of TSC2007 here).
> 
> Do it in userspace and either loop the events back into kernel (after
> parsing) via uinput or feed directly into your framework.

There is even code out there already which does exactly that:

http://svn.o-hand.com/view/misc/trunk/zaurusd/apps/tskeys/tskeys.c?rev=415&view=markup

Cheers,

Richard

