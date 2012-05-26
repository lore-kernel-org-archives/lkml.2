Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2EZJ3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 05:29:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:50372 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2EZJ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 05:29:39 -0400
Date: Sat, 26 May 2012 11:27:12 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Message-ID: <20120526092712.GA4092@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120526084328.GE24149@n2100.arm.linux.org.uk>
References: <20120526084328.GE24149@n2100.arm.linux.org.uk>
  <cover.1337959750.git.rubini@gnudd.com>
 <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	default y if STA2X11
> 
> I don't think we want to encourage an ever growing list of platforms
> here.  If we did this on ARM, this would be hellishly long.

Ok.

> NAK.  We have interfaces in the AMBA code for dynamically allocating
> AMBA devices now - please use them instead of coding your own.  They
> avoid bugs.

Sure. Thanks for noting. Maybe it wasn't there when I coded this
initially. Will do.

>> +	printk(KERN_INFO "%s %i\n", __func__, __LINE__);
> 
> This looks like debugging.

Yes. After sending I noted this and another point. I apologize.
Version 2 will be fixed in all respects.

> This comes nowhere close to being sane with the driver model. [...]
> In other words, save off the platform data pointer, unregister the struct
> device, and then free the platform data (it will not be used at that point.)

Thanks a lot for this and also the comments on APB/AHB in the other message.

/alessandro
