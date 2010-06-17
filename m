Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab0FQARm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:17:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18001 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535Ab0FQARj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:17:39 -0400
Message-ID: <000d01cb0db2$7e3f2b80$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <001401cb0c58$33b3ae20$66f8800a@maildom.okisemi.com> <201006151237.30698.arnd@arndb.de> <000801cb0d32$24ca1360$66f8800a@maildom.okisemi.com> <201006161250.45175.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Thu, 17 Jun 2010 09:17:35 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you.
I will try it.

Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML" <linux-kernel@vger.kernel.org>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>
Sent: Wednesday, June 16, 2010 7:50 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Wednesday 16 June 2010, Masayuki Ohtake wrote:
> > > Especially if you want to be able to use tools like 'cat', 'hexdump'
> > > or 'dd' on the file descriptor, you need to implement support for
> > > short reads.
> > I don't know how to test(short read/write access).
> > Could you tell me how to do the above ?
>
> The easiest way is using dd, where you can specify the block
> size as well as input and output offsets.
>
> e.g.
> dd if=/dev/topcliffphub of=testfile bs=7
>
> Should be able to read the contents of the rom completely
> without error conditions, copying seven bytes at a time.
>
> dd if=inputfile of=/dev/topcliffphub bs=1 seek=1024 count=16
>
> would write 16 bytes from inputfile into the rom at position 1024.
>
> Arnd
>



