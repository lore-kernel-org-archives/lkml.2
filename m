Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0I1L46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:56:58 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:35114 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0I1L44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:56:56 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-serial device driver
Date: Tue, 28 Sep 2010 17:26:35 +0530
Message-Id: <20100928115204.M46802@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100928113036.GA15024@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in> <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de> <20100928091520.M79654@admin-gateway.ncra.tifr.res.in> <20100928113036.GA15024@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is this with your patched pl2303 driver, or are you now doing this from
> userspace?

 This is patched pl2303 driver.

> This looks like your driver, not mine, sorry, you are on your own here.
> See my previous emails as to why this should be done in userspace and
> not in the kernel.

Is it possible to control RTS line from user space.

kindly send me some links, regarding doing the things from userspace like controlling
RTS line,adding mark and space parity with the data bytes.


Thanks,
Raj.
