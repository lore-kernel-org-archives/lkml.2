Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0FBJBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:01:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58767 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab0FBJA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:00:59 -0400
Message-ID: <014201cb0231$f68119a0$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jonathan Cameron" <kernel@jic23.retrosnub.co.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
       "Daniel Mack" <daniel@caiaq.de>, "Jonathan Cameron" <jic23@cam.ac.uk>,
       "Wolfram Sang" <w.sang@pengutronix.de>
References: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com><20100601131244.7164b43c.akpm@linux-foundation.org><4C056FEE.3040107@jic23.retrosnub.co.uk> <20100601135430.9c8c28df.akpm@linux-foundation.org>
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver
Date: Wed, 2 Jun 2010 14:29:45 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Andrew Morton" <akpm@linux-foundation.org>
To: "Jonathan Cameron" <kernel@jic23.retrosnub.co.uk>
Cc: "Hemanth V" <hemanthv@ti.com>; <linux-kernel@vger.kernel.org>; 
<linux-omap@vger.kernel.org>; "Daniel Mack" <daniel@caiaq.de>; "Jonathan 
Cameron" <jic23@cam.ac.uk>; "Wolfram Sang" <w.sang@pengutronix.de>
Sent: Wednesday, June 02, 2010 2:24 AM
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver


> On Tue, 01 Jun 2010 21:39:10 +0100
> Jonathan Cameron <kernel@jic23.retrosnub.co.uk> wrote:
>
>> >
>> > It would be most useful if the changelog were to fully describe the
>> > proposed kernel<->userspace interface.  That's the most important part
>> > of the driver, because it's the only part we can never change.
>> >
>> > There is a desultory effort to maintain sysfs API descriptions under
>> > Documentation/ABI/.  I'd have thought that it would be appropriate to
>> > document this driver's ABI in there.
>> Agreed, but we get back to the debate of what we should standardise on.
>
> I'd suggest standardising on one of the existing drivers.  That way we
> have two compliant drivers and only need to change (n-2) others.  If we
> pick some new standard then we need to change (n) drivers.
>

Currently this driver follows the same sysfs convention as supported
by isl29003.c in drivers/misc. 

