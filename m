Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2GMKPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:15:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:50742 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab2GMKPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:15:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="171386430"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roland Dreier <roland@purestorage.com>
Subject: RE: [3.5-rc6+] mei: irq: request_threaded_irq is missing the
 IRQF_ONESHOT flag
Thread-Topic: [3.5-rc6+] mei: irq: request_threaded_irq is missing the
 IRQF_ONESHOT flag
Thread-Index: AQHNYNyjh614hcAtKkC2UnpyqshXDpcm/DeQ
Date: Fri, 13 Jul 2012 10:15:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B13B4A9@HASMSX103.ger.corp.intel.com>
References: <CA+icZUVorJNMQ3wyz8WuZop_fwwOuBo38wZg9s9RJizhM0yc-w@mail.gmail.com>
In-Reply-To: <CA+icZUVorJNMQ3wyz8WuZop_fwwOuBo38wZg9s9RJizhM0yc-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6DAFcLM014016



> -----Original Message-----
> From: Sedat Dilek [mailto:sedat.dilek@gmail.com]
> Sent: Friday, July 13, 2012 12:48 PM
> To: Winkler, Tomas
> Cc: Thomas Gleixner; LKML; Greg Kroah-Hartman; Roland Dreier
> Subject: [3.5-rc6+] mei: irq: request_threaded_irq is missing the
> IRQF_ONESHOT flag
> 
> Hi,
> 
> while dealing with [1], I saw this mei-related infos in dmesg when doing a
> suspend + resume (see [1] for more logs):

The fix is included in this post pull request http://marc.info/?l=linux-kernel&m=134201523903406&w=2

Thanks
Tomas


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
