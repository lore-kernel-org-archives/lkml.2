Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab2BOH3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:29:49 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:34161
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751295Ab2BOH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:29:45 -0500
X-SpamScore: -8
X-BigFish: VS-8(zz9371I542M1432N98dKzz1202hzz8275bh8275dha509lz2dh2a8h668h839h8e2h8e3h93fhbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Li Yang-R58472 <r58472@freescale.com>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Topic: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Index: AQHM66YJdm8vLXgwC0qeBDGVItKLnJY98mYA//+chbA=
Date: Wed, 15 Feb 2012 07:29:36 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB702B124@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
 <CADRPPNQ8LUr13J4k8fsBYSSxXVuxFdEvKyL4abxZpY32Meh=uQ@mail.gmail.com>
In-Reply-To: <CADRPPNQ8LUr13J4k8fsBYSSxXVuxFdEvKyL4abxZpY32Meh=uQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.94]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1F7U1DS014664

> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org [mailto:linux-ide-
> owner@vger.kernel.org] On Behalf Of Li Yang
> Sent: Wednesday, February 15, 2012 3:22 PM
> To: Liu Qiang-B32616
> Cc: jgarzik@pobox.com; linux-ide@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2 RESEND] fsl-sata: I/O load balancing
> 
> On Wed, Feb 15, 2012 at 1:49 PM, Qiang Liu <qiang.liu@freescale.com>
> wrote:
> 
> Hi Liu Qiang,
> 
> The patch is fine except for the title and comment.  It's too vague to
> say I/O load balancing.  You need explicit description like "add
> interrupt coalescing support" as title.
> 
> > Reduce interrupt signals through reset Interrupt Coalescing Control Reg.
> > Provide dynamic method to adjust interrupt signals and timer ticks by
> sysfs.
> > It is a tradeoff for different applications.
> 
> How about:
> 
> Adds support for interrupt coalescing feature to reduce interrupt events.
> Provides mechanism of adjusting coalescing count and timeout tick by
> sysfs on runtime, so that tradeoff of latency and CPU load can be made
> depending on applications.
> 
Ok, I will change the title and comments more specifically.

> - Leo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
