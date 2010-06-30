Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0F3Nrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:47:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0F3Nrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EqyHIg7OQg+CHSeHPv3UM31l8HonAR5a7W90tdQVB/YP0O9kxLgeBAyQaNRh0sCD2x
         mBVM7ZBKpOeexWbhH+cXxO16g7BNbZAZ7avz5agKVQ29n8dlDc8GDloH+sOenJHkj41M
         VjZIJMf7yiF4pVvayH7ttmekKPVo2EC2kIr2U=
Date: Wed, 30 Jun 2010 06:47:50 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup
 events from being lost
Message-ID: <20100630134750.GA16978@gvim.org>
Reply-To: markgross@thegnar.org
References: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
 <201006282101.54041.rjw@sisk.pl>
 <20100630091038.6af2a53b@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630091038.6af2a53b@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 09:10:38AM +0200, Florian Mickler wrote:
> Hi Rafael!
> 
> On Mon, 28 Jun 2010 21:01:53 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday, June 28, 2010, Alan Stern wrote:
> > > On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Make it possible to avoid wakeup events from being lost
> 
> I have nothing substantial to add, but just wanted to let you know that
> this approach seems like a good alternative to me. As far as I can see
> the userspace suspend-blocker interface could be expressed in terms of
> this kernel facility which brings android closer to mainline.
> 
> The only thing I haven't thought through yet is the 'maintain a discrete
> set of constraints' vs 'just increment a number' thing. Especially if
> what we loose in information through that (in comparison to 'the other
> approach') is made up for by easier in-kernel-API.  I _think_ if there
> is any need for in-kernel-accounting (i don't know that) it could be
> retro-fitted by using the trace event infrastructure?

Adding ftracing hooks and some less invasive partial state or trace
support to this and pm_qos is likely the next order of business.

--mgross

> 
> Cheers,
> Flo
