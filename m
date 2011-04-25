Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab1DYDoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 23:44:06 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:30291 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758055Ab1DYDoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 23:44:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Date: Mon, 25 Apr 2011 11:44:01 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F6735@mhqms01.moxa.com>
In-Reply-To: <20110425030141.GA23658@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Thread-Index: AcwC9YBpgzDZafOpREOD06sf7fPFKAAA66Jw
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: "Joe Perches" <joe@perches.com>
X-OriginalArrivalTime: 25 Apr 2011 03:44:02.0453 (UTC) FILETIME=[049FCC50:01CC02FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
	I'm not sure what you mean "Can't you do all of this from userspace without any kernel changes needed?". Is there anyway to trigger the I/O control from userspace without driver? V2100 boards connect I/O to uart chip, tuning the I/O will switch the uart chip into different mode. "moxa_serial_io" is not a serial driver; the uart itself is droved by another serial driver such as mxser.c or 8250 driver.

-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Monday, April 25, 2011 11:02 AM
To: Jimmy Chen (陳永達); linux-kernel@vger.kernel.org
Cc: Joe Perches
Subject: Re: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver

On Sun, Apr 24, 2011 at 07:47:23PM -0700, Joe Perches wrote:
> On Mon, 2011-04-25 at 10:35 +0800, Jimmy Chen (陳永達) wrote:
> > Add real function and GPL license.
> > Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
> 
> A few things.
> 
> o Your patches are reversed.
> o Please run your patches through checkpatch.
> o I think it better to avoid duplicating all of the GPL
>   and just reference it as you have via MODULE_LICENSE.
> o You could probably use MODULE_LICENSE("GPL V2")
>   if you want to limit it to V2 only.

And finally, why does this need to be a kernel driver at all?  Can't you
do all of this from userspace without any kernel changes needed?

thanks,

greg k-h
