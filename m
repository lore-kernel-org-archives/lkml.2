Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0HaQRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:17:38 -0400
Received: from ns2.cypress.com ([157.95.67.5]:59801 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0HaQRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:17:37 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
References: <1281140943.4035.7.camel@odc-laptop> <20100831002756.GA8304@kroah.com>
Subject: RE: [PATCH] West Bridge Astoria Driver 2.6.35
Date: Tue, 31 Aug 2010 09:17:18 -0700
Organization: Cypress Semiconductor
Message-ID: <DA59ECC057A74C138BDCDA5E93771F77@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20100831002756.GA8304@kroah.com>
Thread-Index: ActIpCFBHPDb/OkAQCOJ63QlE55XcwAg5GPw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I get a build error when I try to build this driver:
>
drivers/staging/westbridge/astoria/block/../include/linux/westbridge/c>
yasmisc.h:521:2: error: expected declaration specifiers or '...' before  >
'cy_as_hal_device_tag'

> It looks like the #include mess isn't working quite properly.

> Also note that this driver is building on an x86-64 platform, which is
> something that you probably don't want :)

> So, for now, I'll just mark the driver as CONFIG_BROKEN and can you send
> me some Kconfig patches against the next linux-next release which should
> have this driver in it, so that it will build properly?

Sure, I can do that. I have since changed the Kconfig structure a bit. It
actually will build properly with the correct .config as it is though. I can
send you the .config if you would like.

Thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

