Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1KXHtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:49:09 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:59465
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab1KXHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:49:07 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Liu Shuo-B35362 <B35362@freescale.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
Thread-Topic: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
Thread-Index: AQHMqkxsR1hJSS+pyE+oUyIsXX6iVZW8CQcA//+cmWA=
Date: Thu, 24 Nov 2011 07:49:03 +0000
Message-ID: <3F607A5180246847A760FD34122A1E052DC61F@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1322095306-13156-1-git-send-email-b35362@freescale.com>
	 <1322095306-13156-3-git-send-email-b35362@freescale.com>
 <1322120515.24797.296.camel@sauron.fi.intel.com>
In-Reply-To: <1322120515.24797.296.camel@sauron.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.80]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAO7nGwV012656

> Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
> large-page Nand chip
> 
> On Thu, 2011-11-24 at 08:41 +0800, b35362@freescale.com wrote:
> > +               /*
> > +                * Freescale FCM controller has a 2K size limitation of buffer
> > +                * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
> > +                * of chip is greater than 2048.
> > +                * We malloc a large enough buffer (maximum page size is
> 16K).
> > +                */
> > +               elbc_fcm_ctrl->buffer = kmalloc(1024 * 16 + 1024,
> GFP_KERNEL);
> 
> Are there NANDs with 16KiB page size?

We are not sure, but are there possibility that chip with 16K page will appear?  Or maybe we can add a MACRO for the maximum page size?

- Leo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
