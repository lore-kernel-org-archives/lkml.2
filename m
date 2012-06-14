Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2FNB5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:57:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:35794 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2FNB5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156110267"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: David Rientjes <rientjes@google.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH v3] testusb: add path /dev/bus/usb to default search
 paths of usbfs
Thread-Topic: [PATCH v3] testusb: add path /dev/bus/usb to default search
 paths of usbfs
Thread-Index: AQHNN+cp9BusCFthtkWJbyjs7xMVX5b4fvmAgACvzZA=
Date: Thu, 14 Jun 2012 01:57:11 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A07B3AD@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
 <20120613231539.GA8891@kroah.com>
In-Reply-To: <20120613231539.GA8891@kroah.com>
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

> On Tue, May 22, 2012 at 06:50:24AM +0000, Du, ChangbinX wrote:
> > As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
> > are mostly used today, let testusb tool use that directory as one
> > default path make tool be more convenient to use.
> >
> > Signed-off-by: Du Changbin <changbinx.du@intel.com>
> 
> This patch does not apply, what tree did you make it against?  Can you redo it
> against the next linux-next release and resend it so I can apply it?

I am very sorry about this. I found this patch has already applied on your tree a 
Month ago. But I had missed the response mail and resent the patch a week later.
I think you could just drop this patch because it has no different with last one.

Thanks!
Changbin

> 
> thanks,
> 
> greg k-h
