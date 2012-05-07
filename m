Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2EGKqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2EGKqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:46:02 -0400
Message-ID: <4FA7A7D8.7000806@redhat.com>
Date: Mon, 07 May 2012 07:45:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: drivers: Probable misuses of ||
References: <1333580415.23520.29.camel@joe2Laptop>
In-Reply-To: <1333580415.23520.29.camel@joe2Laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malcolm,

Em 04-04-2012 20:00, Joe Perches escreveu:
> Likely these should be && not ||
> 
> drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)

> drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)

Could you please take a look on the above?

Thanks!
Mauro

> drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))
> 
> 

