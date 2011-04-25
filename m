Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab1DYOOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:14:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab1DYOOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:14:24 -0400
Date: Mon, 25 Apr 2011 07:13:54 -0700
From: Greg KH <gregkh@suse.de>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] misc: add real function open/read/write/ioctl/close
 for moxa_serial_io driver
Message-ID: <20110425141354.GA28457@suse.de>
References: <20110425030141.GA23658@suse.de>
 <ECB3782BB8F03341905DD923270296115F6735@mhqms01.moxa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ECB3782BB8F03341905DD923270296115F6735@mhqms01.moxa.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Mon, Apr 25, 2011 at 11:44:01AM +0800, Jimmy Chen (陳永達) wrote:
> Greg,
> I'm not sure what you mean "Can't you do all of this from userspace
> without any kernel changes needed?". Is there anyway to trigger the
> I/O control from userspace without driver? V2100 boards connect I/O to
> uart chip, tuning the I/O will switch the uart chip into different
> mode. "moxa_serial_io" is not a serial driver; the uart itself is
> droved by another serial driver such as mxser.c or 8250 driver.

What's wrong with using outb() from your userspace program instead of
writing to this random misc device with some random ioctl calls?

thanks,

greg k-h
