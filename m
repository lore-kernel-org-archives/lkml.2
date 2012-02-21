Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2BUPBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:01:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2BUPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:01:40 -0500
Date: Tue, 21 Feb 2012 16:01:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: Re: [PATCH v2] HID: use generic driver for Logitech Unifying receivers
 if CONFIG_HID_LOGITECH_DJ=n
In-Reply-To: <20120213101303.8665.76516.stgit@zurg>
Message-ID: <alpine.LNX.2.00.1202211600420.31150@pobox.suse.cz>
References: <20120213080644.6105.54221.stgit@zurg> <20120213101303.8665.76516.stgit@zurg>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012, Konstantin Khlebnikov wrote:

> Before commit 534a7b8e1 "HID: Add full support for Logitech Unifying receivers"
> Logitech Unifying receiver can work as generic device without special driver,
> after that commit these devices does not works without special driver.
> 
> After this patch they will use generic driver if special driver is disabled.
> 

Okay, I haven't originally fully realized that this device works 
flawlessly in "single" case without the driver.

I like to avoid polluting the have_special_driver[] with ifdefs, but in 
this particular case it seems to make sense. So I am queuing this.

Thanks.

-- 
Jiri Kosina
SUSE Labs
