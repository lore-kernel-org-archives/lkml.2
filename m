Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271Ab2B2CzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:55:16 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:40345
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966223Ab2B2CzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:55:14 -0500
X-SpamScore: -8
X-BigFish: VS-8(zz9371I542M1432N98dKzz1202hzz8275bh8275dha509lz2dh2a8h668h839h8e2h8e3h93fhbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Qiang-B32616 <B32616@freescale.com>
To: "jgarzik@pobox.com" <jgarzik@pobox.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH V3] fsl-sata: add support for interrupt coalsecing
 feature
Thread-Topic: [PATCH V3] fsl-sata: add support for interrupt coalsecing
 feature
Thread-Index: AQHM67WdcNoMJfMDDUGK7Qc56n5l4pY9+mOAgBVIlnA=
Date: Wed, 29 Feb 2012 02:54:58 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70424A8@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1329291634-883-1-git-send-email-qiang.liu@freescale.com>
 <CADRPPNTmRvPVymJmW4vagU+2M4DmqeDSEj=4=R_=YDJekOTccQ@mail.gmail.com>
In-Reply-To: <CADRPPNTmRvPVymJmW4vagU+2M4DmqeDSEj=4=R_=YDJekOTccQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1T2u5PH031286

Hi Jeff,

Do you plan to apply it to upstream, or any suggestions? Thanks.

> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org [mailto:linux-ide-
> owner@vger.kernel.org] On Behalf Of Li Yang
> Sent: Wednesday, February 15, 2012 3:51 PM
> To: Liu Qiang-B32616
> Cc: jgarzik@pobox.com; linux-ide@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org
> Subject: Re: [PATCH V3] fsl-sata: add support for interrupt coalsecing
> feature
> 
> On Wed, Feb 15, 2012 at 3:40 PM, Qiang Liu <qiang.liu@freescale.com>
> wrote:
> > Adds support for interrupt coalescing feature to reduce interrupt
> events.
> > Provides a mechanism of adjusting coalescing count and timeout tick by
> > sysfs at runtime, so that tradeoff of latency and CPU load can be made
> > depending on different applications.
> >
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> 
> Acked-by: Li Yang <leoli@freescale.com>
> 
> - Leo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
