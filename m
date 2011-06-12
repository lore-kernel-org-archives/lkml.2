Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1FLU1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 16:27:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab1FLU1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 16:27:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal Time to the printk.
Date: Sun, 12 Jun 2011 22:27:32 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
References: <1307599301-2524-1-git-send-email-justinmattock@gmail.com> <201106122035.26600.rjw@sisk.pl> <4DF514BC.9030808@gmail.com>
In-Reply-To: <4DF514BC.9030808@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106122227.32992.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 12, 2011, Justin P. Mattock wrote:
> On 06/12/2011 11:35 AM, Rafael J. Wysocki wrote:
> > On Sunday, June 12, 2011, Justin P. Mattock wrote:
> >> On 06/12/2011 05:12 AM, Rafael J. Wysocki wrote:
> >>> Hi,
> >>>
> >>> On Thursday, June 09, 2011, Justin P. Mattock wrote:
> >>>> From: "Justin P. Mattock"<justinmattock@gmail.com>
> >>>>
> >>>> sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed
> >>>> wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
> >>>> "UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!
> >>>>
> >>>> before:
> >>>> [    0.114915] Time:  1:47:03  Date: 06/09/11
> >>>>
> >>>> after:
> >>>> [    0.114728] Time:  5:46:02 UTC Date: 06/09/11
> >>>>
> >>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >>>
> >>> I suspect the goal is to mark messages printed by the PM trace code so that
> >>> they can be easily distinguished from messages from other sources to avoid
> >>> confusion.  Why do you think it's a good idea to use the "UTC" string for
> >>> this purpose?  The time printed in those messages need not be UTC.
> >>>
> >>> It would be better to simply print "RTC time: ..., date: ..." IMO.
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>
> >> well.. if thats better, then thats better.. over here(people that dont
> >> know what RTC time is) would not get so confused with a simple UTC or
> >> PDT or whatever the time zone is but if RTC is bettr, then its better.
> >
> > My point is we don't know this time is always UTC, so we rather shouldn't
> > label it as UTC unconditionally, should we?
> >
> > Rafael
> >
> 
> sounds good to me!!

I'm not sure what you mean?
