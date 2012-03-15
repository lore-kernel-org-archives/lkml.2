Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054Ab2COVXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:23:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34194 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2COVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:23:42 -0400
Date: Thu, 15 Mar 2012 14:23:38 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Alexandra Sava <alexandrasava18@gmail.com>
Cc: "Savoy, Pavan" <pavan_savoy@ti.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        "mgherzan@gmail.com" <mgherzan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ti-st: Enhange logging for Shared Transport - TI driver
Message-ID: <20120315212338.GA22983@kroah.com>
References: <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
 <CAEnQRZBDxB5Vb7XTFKmdrvQOcWKQU0SWO4HExvDmFbEv_AMnQw@mail.gmail.com>
 <0F08A04750B6BE499D6FAC390A6128A231758C32@DBDE01.ent.ti.com>
 <CAMFpKOjymX4N-w=cKMUaM6k3xBnN_SYVk9eDBhi37xjT4D0YWQ@mail.gmail.com>
 <CAMFpKOjphDX0HbaReZCNHtux=j1LSpEK6nU3thddqFUHXUCiuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMFpKOjphDX0HbaReZCNHtux=j1LSpEK6nU3thddqFUHXUCiuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:17:25PM +0200, Alexandra Sava wrote:
> On 15 March 2012 23:10, Alexandra Sava <alexandrasava18@gmail.com> wrote:
> > On 15 March 2012 22:29, Savoy, Pavan <pavan_savoy@ti.com> wrote:
> >> Daniel Baluta wrote:
> >>> Adding Greg's new email address.
> >>>
> >>> On Thu, Mar 15, 2012 at 8:26 PM,  <alexandrasava18@gmail.com> wrote:
> >>>> From: Alexandra Sava <alexandrasava18@gmail.com>
> >>>>
> >>>> * added new module parameter named debug_mask to control displayed
> >>>> messages verbosity
> >>>> * the logging mechanism is enabled via CONFIG_TI_ST_DEBUG Kconfig
> >>>> option
> >>
> >> Any specific reason you want to have this ? Custom logging ?
> >> Also please fix the spelling in the subject line.
> >>
> >
> > The logging for this driver is too verbose, and I thought it would be
> > better to implement a configurable mechanism which can enable/disable
> > the log messages (not only via the global CONFIG_DYNAMIC_DEBUG).
> > So, I think there are two ways:
> 
> The logging for this driver is too verbose, and I thought it would be
> better to implement a configurable mechanism which can enable/disable
> the log messages (not only via the global CONFIG_DYNAMIC_DEBUG).
> So, I think there are two ways:
> 	1. keep pr_debug but reduce the amount of messages

That's probably the best, you aren't needing almost all of them anymore
now that the driver is working.

> 	2. make the logs configurabile via CONFIG_TI_SI_DEBUG

No, don't do this, no one will enable it.

greg k-h
