Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2D3GmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:42:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2D3GmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:42:05 -0400
Date: Sun, 29 Apr 2012 23:41:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [Patch] Touch: DA9052/53 touch screen driver v2
Message-ID: <20120430064158.GA21023@core.coreip.homeip.net>
References: <1334924925.3752.14.camel@dhruva>
 <20120421063855.GA2360@core.coreip.homeip.net>
 <C3AE124F08223B42BC95AEB82F0F6CED2D562697@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED2D562697@KCHJEXMB02.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:46:52PM +0000, Ashish Jangam wrote:
> > > On Fri, Apr 20, 2012 at 05:58:45PM +0530, Ashish Jangam wrote:
> > > Why did you switch to using irq_base here? da9052_onkey driver does not
> > > do that, should it?
> > On i.mx53 loco board irq_base was required so to keep driver working across
> > boards this was introduced. Need to fix this in onkey driver.
> > >
> > > Thanks.
> If the patch looks good then please ACK it. 

Applied to the 3.5 queue, thank you.

-- 
Dmitry
