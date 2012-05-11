Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab2EKSET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:04:19 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:15329 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2EKSER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:04:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1336759447!19163318!8
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Date: Fri, 11 May 2012 13:04:08 -0500
Subject: RE: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Thread-Topic: [PATCH] staging: comedi: Add helper macro for comedi pci
 driver boilerplate
Thread-Index: Ac0vn+LdRs+SRKsDT7uWpw6z0ib5VAAAB3kg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17EA9@AUSP01VMBX24.collaborationhost.net>
References: <201205111007.46754.hartleys@visionengravers.com>
 <20120511175954.GA7920@kroah.com>
In-Reply-To: <20120511175954.GA7920@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 11, 2012 11:00 AM, Greg KH wrote:
> On Fri, May 11, 2012 at 10:07:43AM -0700, H Hartley Sweeten wrote:
>> --- a/drivers/staging/comedi/drivers.c
>> +++ b/drivers/staging/comedi/drivers.c

<snip>

>> +EXPORT_SYMBOL(comedi_pci_driver_register);

<snip>

>> +EXPORT_SYMBOL(comedi_pci_driver_unregister);
>
> EXPORT_SYMBOL_GPL() for these two functions?

I wasn't sure about that...

Question.. when "should" EXPORT_SYMBOL be used and
when should it be EXPORT_SYMBOL_GPL?

Also, do you have any comments on Ian Abbott's comment
about the:

> +	pci_driver->name = comedi_driver->driver_name;

In the register function?

Regards,
Hartley

