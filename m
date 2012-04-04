Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2DDXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:00:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43035 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932468Ab2DDXAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:00:16 -0400
Message-ID: <1333580415.23520.29.camel@joe2Laptop>
Subject: drivers: Probable misuses of ||
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 04 Apr 2012 16:00:15 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Likely these should be && not ||

drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)
drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))


