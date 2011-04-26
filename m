Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1DZN2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:28:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:52629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1DZN2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:28:18 -0400
Date: Tue, 26 Apr 2011 06:20:41 -0700
From: Greg KH <gregkh@suse.de>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] misc: add real function open/read/write/ioctl/close
 for moxa_serial_io driver
Message-ID: <20110426132041.GB13597@suse.de>
References: <20110425141354.GA28457@suse.de>
 <ECB3782BB8F03341905DD923270296115F6A7D@mhqms01.moxa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ECB3782BB8F03341905DD923270296115F6A7D@mhqms01.moxa.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 05:01:23PM +0800, Jimmy Chen (陳永達) wrote:
> Greg,
> Thank for the advices. Yes, we think of accessing the I/O in user
> space level
> (http://www.faqs.org/docs/Linux-mini/IO-Port-Programming.html#s1).
> However, the driver has been used for many years in our product
> including ARM9/ARM11 series platform (note that #ifdef code have been
> removed in this patch). That the reason why we expect to remain the
> consistency during user access. Also, the driver will be used to
> support different arch in the future.

Just because you created a messy/bad user/kernel interface in the past
doesn't mean we are forced to take it :)

I have been aware of this code for a very long time, and I disagreed
with it years ago when I first saw it, yet my opinion seemed to be
ignored then for this same reason.

We don't add code to the kernel that is not necessary, and this code is
not necessary at all as you can do the whole thing from userspace.
Please do it there.

thanks,

greg k-h
