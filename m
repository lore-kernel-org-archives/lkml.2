Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2ENDbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:31:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:18069 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab2ENDbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:31:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99661619"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Thread-Topic: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Thread-Index: AQHNL1p/cPl9Qq41ikap8bVWXEqTwJbEa8gQgAA01ACABAJikA==
Date: Mon, 14 May 2012 03:31:14 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A062A08@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A060D0C@SHSMSX101.ccr.corp.intel.com>
 <20120511220920.GD13675@kroah.com>
In-Reply-To: <20120511220920.GD13675@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry I haven't consider of that. I just want testusb tool can work with default option since path /dev/bus/usb exists on most computer, not /proc/bus/usb.
So, if I just add /dev/bus/usb to the default search path, is it ok? Thanks.

-----Original Message-----
From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org] 
Sent: Saturday, May 12, 2012 6:09 AM
To: Du, ChangbinX
Cc: mina86@mina86.com; Fleming, Matt; balbi@ti.com; hpa@zytor.com; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/3] testusb: using real device-nodes managed by udev instead of using usbfs

On Fri, May 11, 2012 at 11:02:01AM +0000, Du, ChangbinX wrote:
> As the usbfs functionality have replaced by real device-nodes managed by udev whose nodes lived in /dev/bus/usb for a long time, testusb tool need update correspondingly.

Why?  Is this causing problems as it is today?

> Because udev path is fixed, so the "-A" option no longer need and it is removed.

Did you just break scripts that was using that option?  That's not nice, and not acceptable.

greg k-h
