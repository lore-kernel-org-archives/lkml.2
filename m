Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IBGUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:20:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61039 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0IBGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pfn/8T3nusH8sqXwpPmtItVaA2nkYR5ztmld1DxKE66dQXO7+aHPUk73mtmGpR9nwL
         omonpyNI2Ty+JFs8jXsWS+AKNsrPuEY+KpLjjJKHq/a8hqzYPfT+OZoN2sgBDmmzV+wH
         NPE3nBVwB4D2aP8ozN2Dmfu5ucdq1/mC+SVx4=
Date: Wed, 1 Sep 2010 23:20:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jkosina <jkosina@suse.cz>,
        Peter Hutterer <peter.hutterer@redhat.com>
Subject: Re: [PATCH v3] input: Add support for Hanwang tablet
Message-ID: <20100902062030.GA9416@core.coreip.homeip.net>
References: <201009021229501252232@hanwang.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009021229501252232@hanwang.com.cn>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 12:29:50PM +0800, Xing Wei wrote:
> On Wed, Sep 01, 2010 mitry Torokhov wrote:
> > Hi Xing,
> > 
> > On Wed, Sep 01, 2010 at 02:55:44PM +0800, Xing Wei wrote:
> > > Hi Dmitry, it works well and I really appreciate your work. 
> > > BTN_3 - BTN_8 & ABS_DISTANCE events are not handled & used in our X system driver by now,
> > > sorry for my mistake.
> > >
> > 
> > Just to avoid confusion - are BTN_3 - BTN_8 not used by your X driver or
> > the hardware does not really report them? Because if it the former then
> > we should continue reporting them - some other user (as in
> > program/driver) might be interested in these.
> > 
> > Also, why do you develop your own X driver? Does not X's evdev driver
> > work properly for you?
> > 
> > Thanks.
> >  
> > 
> 
> Hi Dmitry, the hardware does really report BTN_3 - BTN_8.

OK, then we should keep reporting them then. I will add the patch to my
'next' branch and it should show up in 2.6.37.

> And I try to let the evdev driver(remove my X driver & .conf file ) take over the device,
> but seem like it has no reflection to the pressure and roll wheel pad,just run like a generic mouse.
> 

Then I suggest looking into modifying evdev so that it properly works
with your device. I think Peter Hutterer (CCed) is the man you need to
talk to.

Thanks.

-- 
Dmitry
