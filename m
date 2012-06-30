Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2F3Df1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:35:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61326 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2F3Df0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:35:26 -0400
Date: Fri, 29 Jun 2012 23:35:19 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120630033519.GA4792@kroah.com>
References: <20120628131651.GA14492@gherkin.frus.com>
 <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
 <20120629033600.GA3591@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629033600.GA3591@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:36:00PM -0500, Bob Tracy wrote:
> On Thu, Jun 28, 2012 at 09:39:45PM +0800, Ming Lei wrote:
> > On Thu, Jun 28, 2012 at 9:16 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> > > With the removal of the deprecated usbfs feature in the 3.5 release
> > > candidates, is there a way of getting USB devices working on a non-
> > > embedded Linux system without udev (static "/dev")?
> > 
> > Please try to enable below options:
> > 
> > CONFIG_DEVTMPFS=y
> > CONFIG_DEVTMPFS_MOUNT=y
> > 
> > and you need not the static dev nodes with devtmpfs.
> 
> It was worth a try, but it didn't help in my situation.

Why not?  What is using usbfs device nodes that can not find them in
/dev/bus/usb/ that devtmpfs creates?

thanks,

greg k-h
