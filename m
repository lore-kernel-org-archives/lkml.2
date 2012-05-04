Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab2EDVyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:54:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323Ab2EDVyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:54:40 -0400
Message-ID: <1336168477.11505.6.camel@joe2Laptop>
Subject: Re: drivers: Probable misuses of ||
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 04 May 2012 14:54:37 -0700
In-Reply-To: <1333580415.23520.29.camel@joe2Laptop>
References: <1333580415.23520.29.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 16:00 -0700, Joe Perches wrote:
> Likely these should be && not ||
> 
> drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)
> drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))

It's been a month.

Do you maintainers not care
about these obvious defects?

