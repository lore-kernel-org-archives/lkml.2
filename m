Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2JWIaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:30:25 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:23089 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:30:20 -0400
From: =?big5?B?vEK5xcJA?= <scott.liu@emc.com.tw>
To: "'Jian-Jhong Ding'" <jj_ding@emc.com.tw>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Benjamin Tissoires'" <benjamin.tissoires@gmail.com>,
        "'Jesse'" <jesse@emc.com.tw>,
        "'Vincent Wang'" <vincent.wang@emc.com.tw>,
        "'Paul'" <paul.liang@emc.com.tw>
Subject: RE: [PATCH v1] Support Elan Touchscreen eKTF product.
Date: Tue, 23 Oct 2012 16:30:18 +0800
Message-ID: <7BC14E6A36624121B78375F1425F9C32@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <87pq4aq6if.fsf@emc.com.tw>
Thread-Index: Ac2wxCLydY2eWF9yRoyEV4sZdlIKGAAM01pg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry:
	This driver is not related to Tom's driver. This driver is ELAN
standard I2C driver for touch panel and its packets is defined by ELAN own
format and not related to HID over I2C.

Thanks,
Scott

> -----Original Message-----
> From: Jian-Jhong Ding [mailto:jj_ding@emc.com.tw]
> Sent: Tuesday, October 23, 2012 10:15 AM
> To: Dmitry Torokhov
> Cc: Scott Liu; linux-input@vger.kernel.org; linux-i2c@vger.kernel.org;
> linux-kernel@vger.kernel.org; Benjamin Tissoires; Jesse; Vincent Wang;
Paul
> Subject: Re: [PATCH v1] Support Elan Touchscreen eKTF product.
> 
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> > On Mon, Oct 22, 2012 at 11:47:42AM +0800, Jian-Jhong Ding wrote:
> >> With Benjamin's i2c-hid implimentation, is it possible to make
> >> hid-multitouch not depend on USBHID and reuse it to drive this device?
> >
> > Exactly. Before looking any further - is this the same part that Tom Lin
> > posted a driver for earlier this summer?
> 
> No.  Tom's driver was only for trackpads, this is probably for some
> touch panel.  The controller ICs may have some similarities, but the
> firmware is developed independently, though both somewhat conform to the
> HID over I2C protocol.
> 
> Thanks,
> -JJ
> > Thanks.
> >
> > --
> > Dmitry

