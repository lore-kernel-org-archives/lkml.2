Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2DMMnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:43:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab2DMMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:43:17 -0400
Date: Fri, 13 Apr 2012 14:43:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: =?GB2312?B?wdaPqdPT?= <tom_lin@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
In-Reply-To: <CAN+gG=EQ-B8_brthJnrq0pw1HYGo15Q6unaEQAbu-e2x10z0XA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204131442520.16373@pobox.suse.cz>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw> <20120411071212.GB6894@core.coreip.homeip.net> <4F85583F.6050008@emc.com.tw> <20120411162519.GA27562@core.coreip.homeip.net> <4F8631C8.1090705@emc.com.tw>
 <CAN+gG=EQ-B8_brthJnrq0pw1HYGo15Q6unaEQAbu-e2x10z0XA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Benjamin Tissoires wrote:

> I read Microsoft's things about HID over I2C few days ago. And from
> what I understood, the report descriptors and the enumeration of the
> devices are stored in the ACPI table and not in the device itself. Can
> you confirm this?
> 
> I was thinking about making hid-multitouch independent from the usb
> stack and was thinking about doing the i2c-hid bridge. However, I did
> not start writing a line yet ;-)

I guess you were planning to write that as a HID transport (ll) driver, 
right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
