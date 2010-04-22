Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0DVDpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 23:45:05 -0400
Received: from kroah.org ([198.145.64.141]:34214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0DVDpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:45:04 -0400
Date: Wed, 21 Apr 2010 20:41:24 -0700
From: Greg KH <greg@kroah.com>
To: YuPing Luo <YuPing.Luo@csr.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: core: workque: workqueue recursion when unplugging usb WCDMA
	modem on 2.6.32 kernel
Message-ID: <20100422034124.GA25155@kroah.com>
References: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI> <20100421182747.GB7876@kroah.com> <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 08:15:52PM -0700, YuPing Luo wrote:
> > > On Tue, Apr 20, 2010 at 11:27:55PM -0700, YuPing Luo wrote:
> > Is your console on a usb to serial device?  Or a serial port?
> > if usb to serial, can you try .33-rc5 and let us know if that solves
> the problem?
> > greg k-h
> 
>  The console is over serial port, while the usb modem exported 2 serial
> ports .
>  The recursion can be avoided if introducing one dedicated work queue
> thread for binder (
> http://android.git.kernel.org/?p=kernel/common.git;a=blob;f=drivers/stag
> ing/android/binder.c;h=99010d4b3044b2c33c9d709e334b5be7871b9599;hb=andro
> id-2.6.32).

Ah, it's a binder issue.  Good luck with that, you are on your own with
that monster :)

greg k-h
