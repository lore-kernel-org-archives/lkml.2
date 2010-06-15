Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0FOU4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:56:07 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:34334 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab0FOU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:56:05 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Jassi Brar <jassisinghbrar@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "yuanyabin1978@sina.com" <yuanyabin1978@sina.com>,
       Viresh KUMAR <viresh.kumar@st.com>, Alessandro Rubini <rubini@unipv.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>
Date: Tue, 15 Jun 2010 22:55:07 +0200
Subject: RE: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
 	PrimeCells
Thread-Topic: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
 	PrimeCells
Thread-Index: AcsMd+q3AYY1yp/CQ8qG58SqACRjuAAVKKeA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025E5AE204@EXDCVYMBSTM006.EQ1STM.local>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<002001cb0c75$0a54fd00$1efef700$%kim@samsung.com>
 <AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
In-Reply-To: <AANLkTil7gb7SjrYPrHPfSomwxLlHpowXOZd_Qr125jvr@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5FKuDim032513

[Jassi]
> [Kukjin]
> >> It has been converted to use the header from the Samsung PL080
> >> derivate instead of its own defintions, and can potentially support
> >> several controllers in the same system.
> > Looks good, but please give me some time to test on the
> board(SMDK6410).
> > If any problem, let you know. Of course no problem, will ack.
> Samsung doesn't use the DMA API, so this driver is unlikely to work.

Yeah that was never the intention, the Samsung derivate has one extra
Register and other funny stuff.

I was more hoping on breaking out a subset in the same elegant way
with a generic part and a separate DMAengine as was done with the
PL330... But I need to get it fully working first.

Atleast I used the same include file.

But I have functional UART DMA on the RealView PB11MPCore now!

Yours,
Linus Walleij
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
