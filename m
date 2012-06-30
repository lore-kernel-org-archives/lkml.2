Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2F3Dgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:36:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60064 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2F3Dg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:36:29 -0400
Date: Fri, 29 Jun 2012 23:36:26 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: no USB keyboard in 3.5-rc1 and later
Message-ID: <20120630033626.GB4792@kroah.com>
References: <20120627013031.GA2681@gherkin.frus.com>
 <20120628060456.GA2132@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628060456.GA2132@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:04:56AM -0500, Bob Tracy wrote:
> On Tue, Jun 26, 2012 at 08:30:31PM -0500, Bob Tracy wrote:
> > Here's hoping it's something simple.  Attached USB devices fail to
> > initialize/work for kernel version 3.5-rc1 and later (up through
> > 3.5-rc4).  From what I can tell from the dmesg output (attached),
> > there used to be an "input" or "generic-usb" message that appeared
> > for each device following detection -- showing the sysfs path to the
> > device.
> 
> The answer *was* simple: the deprecated usbfs under /proc went bye-bye
> starting with 3.5-rc1.  I'm still using a static "/dev" (no "udev").
> Hence, no device nodes under "/dev/bus/usb".

If you are using a static /dev/ then you should just create these nodes
statically and you should be fine, right?

thanks,

greg k-h
