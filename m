Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2BFShB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:37:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59458 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab2BFShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:37:00 -0500
X-Sasl-enc: bnXOPM3CGTF1YMnbbD1iiTWvQjcOJEMbc/7GXra6otwQ 1328553419
Date: Mon, 6 Feb 2012 10:29:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject (ffff88003ffbb4b8): tried to init an initialized object,
 something is seriously wrong.
Message-ID: <20120206182956.GA13819@kroah.com>
References: <20120203205953.GA2897@phenom.dumpdata.com>
 <20120203213949.GC8196@kroah.com>
 <20120203214235.GA10549@kroah.com>
 <20120206182040.GA1862@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206182040.GA1862@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 01:20:40PM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 03, 2012 at 01:42:35PM -0800, Greg KH wrote:
> > On Fri, Feb 03, 2012 at 01:39:49PM -0800, Greg KH wrote:
> > > On Fri, Feb 03, 2012 at 03:59:53PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > Hey Greg,
> > > > 
> > > > With or without your previous patch (the one that added an cpu_device_release
> > > > function) I am getting this in 3.3-rc2.  I did not get this in 3.2.
> > > > 
> > > > I added some extra printks to make sure that the handle_vcpu_hotplug_event
> > > > code actually did call 'arch_unregister_cpu' which is certainly looks
> > > > to be doing.
> > > > 
> > > > I hadn't done a bisection yet, but was wondering if this is related
> > > > to the previous issues with the sysdev. Or kobject getting more observant.
> > > 
> > > No, it's related to the previous issue, let me knock up a patch to fix
> > > this as well...
> > 
> > Does this patch solve the problem for you?
> 
> Yeah, no warnings. But neither is the CPU coming back up :-(

Very wierd.

> Thought that might be related to something else  - let me double check
> with 3.2 whether there are some race-conditions that I might be hitting.

Ok, I'll wait to queue this up until you get back to me.

greg k-h
