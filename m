Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2KBXgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:36:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64965 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab2KBXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:36:14 -0400
Date: Fri, 2 Nov 2012 16:36:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?B?IkphbiBILiBTY2j2bmhlcnIi?= <schnhrr@cs.tu-berlin.de>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
Message-ID: <20121102233610.GA3239@kroah.com>
References: <5064790E.4000207@cs.tu-berlin.de>
 <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
 <5065B909.1060907@cs.tu-berlin.de>
 <CAPXgP12v0aNtUnhKep3QiJwZYAp=NHebHVfS9N35V2EOSmAufg@mail.gmail.com>
 <CAPXgP13GCsooDtbor9_OvyDCZjPARL_On_cBtEoxTUWnVsBpvw@mail.gmail.com>
 <50732F8A.9090109@cs.tu-berlin.de>
 <CAPXgP10ipvmVTEV_e_8+q-xLksVbBaPqWWDfc8H+W8KUPohDLA@mail.gmail.com>
 <CAPXgP13+DWxdU23Z45tLj0H+kjGL_QCi-wYs_LrYypxQVqPndw@mail.gmail.com>
 <50944B16.8010201@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50944B16.8010201@cs.tu-berlin.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 11:37:10PM +0100, "Jan H. Schönherr" wrote:
> Am 02.11.2012 04:53, schrieb Kay Sievers:
> > On Mon, Oct 8, 2012 at 9:56 PM, Kay Sievers <kay@vrfy.org> wrote:
> >> On Mon, Oct 8, 2012 at 9:54 PM, "Jan H. Schönherr"
> > 
> >>>> Jan,
> >>>> any updates, did you try something else?
> >>>> Or should we merge the first version for now?
> >>>
> >>> I'm working on it, though I cannot spend as much time as I want. :)
> >>>
> >>> My current version does mostly well for race-printk()s, now. But
> >>> there's still one issue to resolve and some polishing to do.
> >>>
> >>> If we can afford to wait a little longer, we might get a nicer
> >>> solution (and avoid a possible mostly-revert later).
> >>
> >> Sure, no hurry, I was just going through my TODO emails. :)
> > 
> > My TODO is nagging me again. :)
> > 
> > Any updates? No problems if not, but we should merge the current
> > version then, I think.
> > 
> 
> Then let's take the first version. :)

Someone needs to resend it then, as it's lost to the archives of my
inbox, sorry.

greg k-h
