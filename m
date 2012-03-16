Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032555Ab2CPAvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:51:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41245 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032545Ab2CPAvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:51:11 -0400
Date: Thu, 15 Mar 2012 17:51:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Mircea Gherzan <mgherzan@gmail.com>, alexandrasava18@gmail.com,
        pavan_savoy@ti.com, daniel.baluta@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ti-st: Enhange logging for Shared Transport - TI driver
Message-ID: <20120316005107.GC25310@kroah.com>
References: <y>
 <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
 <4F6289B3.2060204@gmail.com>
 <20120316003523.GA25149@kroah.com>
 <1331858472.5406.21.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331858472.5406.21.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:41:12PM -0700, Joe Perches wrote:
> On Thu, 2012-03-15 at 17:35 -0700, Greg KH wrote:
> > On Fri, Mar 16, 2012 at 01:30:43AM +0100, Mircea Gherzan wrote:
> > > This is what I get now (with no debug) when loading the btwilink module
> > > that uses ti-st:
> > > [  129.567382] (stk) :change remote baud rate command in firmware
> > > [  129.573577] (stk) :skipping the wait event of change remote baud
> > > This is:
> > >  1. too "verbose" => these 2 prints should belong to debug
> > >  2. poorly formated
> > >  3. not telling me which driver generated this output
> > >  4. not giving me the version of the firmware that was loaded.
> > > To address 2 and 3, please remove the the "(stc)" / "(stk)" prefixes and
> > > use instead the quite widespread prefix KBUILD_MODNAME ": "
> > No, just use the proper dev_*() functions instead, it will tell you
> > exactly what driver and device emitted the message, that is what it is
> > there for.
> 
> I generally concur though there might be instances where
> no struct device * is available and pr_<level> is a good
> alternative for those cases.

I agree.
