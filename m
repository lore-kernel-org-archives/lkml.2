Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0FIIxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:53:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45070 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0FIIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:53:14 -0400
Message-ID: <00b801cb07b1$2cce1420$LocalHost@MINX0100354>
From: "Naveen Jain" <naveen_jain@ti.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
       "Savoy, Pavan" <pavan_savoy@ti.com>
References: <1276008885-30282-1-git-send-email-naveen_jain@ti.com> <20100608150310.GA29618@suse.de>
Subject: Re: [PATCH] drivers:staging: ti-st: add version info to sysfs
Date: Wed, 9 Jun 2010 14:23:02 +0530
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

From: "Greg KH" <gregkh@suse.de>
To: "Jain, Naveen" <naveen_jain@ti.com>
Cc: <devel@driverdev.osuosl.org>; <linux-kernel@vger.kernel.org>; "Savoy, 
Pavan" <pavan_savoy@ti.com>
Sent: Tuesday, June 08, 2010 8:33 PM
Subject: Re: [PATCH] drivers:staging: ti-st: add version info to sysfs


On Tue, Jun 08, 2010 at 09:54:45AM -0500, naveen_jain@ti.com wrote:
>> From: Naveen Jain <naveen_jain@ti.com>
>>
>> Cleanup sysfs code, so that all the required sysfs entries
>> are created under /sys/bus/platform/drivers/kim now.

>Where were they ending up?

Earlier the kobject was created under /sys/, and the entries went under 
/sys/uim. The below patch cleans that up.

[PATCH 1/2] drivers:staging: ti-st: cleanup sysfs code



>> Add version information to be available under the sysfs group
>> for kim.

>How about splitting this into two different patches, as they do
>different things?

It is split into two diff patches now.

>thanks,

>greg k-h

