Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2EaM7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:59:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42689 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab2EaM7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:59:33 -0400
X-IronPort-AV: E=Sophos;i="4.75,692,1330934400"; 
   d="scan'208";a="652342866"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Michael Tokarev <mjt@tls.msk.ru>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0+ NFS issues
Thread-Topic: 3.0+ NFS issues
Thread-Index: AQHNPy034olWaj++ikybg8rdGWyBVw==
Date: Thu, 31 May 2012 12:59:31 +0000
Message-ID: <1338469169.2420.7.camel@lade.trondhjem.org>
References: <4FBF2C57.3070203@msgid.tls.msk.ru>
	 <20120529152416.GC3441@fieldses.org> <4FC5C82E.4020806@msgid.tls.msk.ru>
	 <20120530132518.GA13794@fieldses.org> <4FC713ED.5040807@msgid.tls.msk.ru>
In-Reply-To: <4FC713ED.5040807@msgid.tls.msk.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <68C16976A088824A98C10C4ABB2D8A96@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4VCxg2S006774

On Thu, 2012-05-31 at 10:47 +0400, Michael Tokarev wrote:

> 10:38:53.827355 IP (tos 0x0, ttl 64, id 35160, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1396548098 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827379 IP (tos 0x0, ttl 64, id 35161, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1413325314 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827385 IP (tos 0x0, ttl 64, id 35162, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1430102530 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827400 IP (tos 0x0, ttl 64, id 35163, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1446879746 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827406 IP (tos 0x0, ttl 64, id 35164, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1463656962 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827409 IP (tos 0x0, ttl 64, id 35165, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1480434178 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827413 IP (tos 0x0, ttl 64, id 35166, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1497211394 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827417 IP (tos 0x0, ttl 64, id 35167, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1513988610 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827420 IP (tos 0x0, ttl 64, id 35168, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1530765826 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827424 IP (tos 0x0, ttl 64, id 35169, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1547543042 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827427 IP (tos 0x0, ttl 64, id 35170, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1564320258 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827434 IP (tos 0x0, ttl 64, id 35171, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1581097474 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827438 IP (tos 0x0, ttl 64, id 35172, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1597874690 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827443 IP (tos 0x0, ttl 64, id 35173, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1614651906 > 192.168.88.4.2049: 212 getattr fh 0,0/22
> 10:38:53.827447 IP (tos 0x0, ttl 64, id 35174, offset 0, flags [DF], proto TCP (6), length 268)
>     192.168.88.2.1631429122 > 192.168.88.4.2049: 212 getattr fh 0,0/22

That is tcpdump trying to interpret your NFSv4 trace as NFSv2/v3.

Can you either please use wireshark to provide a full text dump (using
something like 'tshark -V -O nfs,rpc'), or just send us the binary
tcpdump output using 'tcpdump -w /tmp/foo -s 90000'?

> >> Can at least the client be made interruptible?  Mounting with
> >> -o intr,soft makes no visible difference...
> 
> please? :)

It already is interruptible: try 'kill -9' or any other fatal signal.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
