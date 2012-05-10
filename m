Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab2EJXwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:52:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2EJXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:52:41 -0400
Date: Thu, 10 May 2012 16:52:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
Message-ID: <20120510235237.GA28601@kroah.com>
References: <1336647288-10858-1-git-send-email-cw00.choi@samsung.com>
 <20120510182015.GB17018@kroah.com>
 <4FAC5313.80909@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC5313.80909@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 08:45:23AM +0900, Chanwoo Choi wrote:
> On 05/11/2012 03:20 AM, Greg KH wrote:
> 
> > On Thu, May 10, 2012 at 07:54:48PM +0900, Chanwoo Choi wrote:
> >> This patchset add support irq domain for Maxim MAX8997 interrupts.
> >>
> >> The first patch is based on patch written by Thomas Abraham and fix
> >> two bug which set max8997->irq_domain instead of NULL pointer and
> >> correct wrong parameter by Chanwoo Choi.
> >> - https://lkml.org/lkml/2012/4/18/145
> >> The second patch use irq domain for MAX8997 muic interrupt instead
> >> of irq_base in platform data of MAX8997 driver.
> >>
> >> But, I posted following patchset related to MAX8997 driver.
> >> This patchset support Extcon framework in extcon-max8997 driver to
> >> control external connector instead of max8997-muic driver. So, first
> >> patch add MAX8997 extcon driver(drivers/extcon/extcon-max8997.c) and
> >> last patch remove old MAX8997 muic driver(drivers/misc/max8997-muic.c).
> >> - https://lkml.org/lkml/2012/5/8/98
> >>
> >> This patchset was applied in below git repository of Greg Kroah-Hartman.
> >> - http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next
> >>
> >> I think that this patchset should be applied on the git repository
> >> of Greg Kroah-Hartman to remove possible conflict issue when merged.
> > 
> > That's fine with me, should the MFD maintainer have been copied on this
> > to get his signed-off-by on it?
> > 
> 
> I knew that first patch written by Thomas Abraham has been already
> confirmed ack message from MFD maintainer(Samuel Ortiz
> <sameo@linux.intel.com>). You can check it on first patch and below git
> repository of Mark Brown.

Ok, but why didn't you cc: him and everyone else who acked and
signed-off on that patch?

> The below patch has occurred build break, so it was reverted by Mark
> Brown. And then I did post this patchset with bug fix.
> 
> http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=98d8618af37728f6e18e84110ddb99987b47dd12

So does that mean this one is ok, but the older one isn't?

confused, what exactly should I do here?

greg k-h
