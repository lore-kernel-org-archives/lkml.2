Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2BQDao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:30:44 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:39790
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395Ab2BQDam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:30:42 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I936eK542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h93fhbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Topic: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Index: AQHM66YJdm8vLXgwC0qeBDGVItKLnJZAprgA//+pphCAAIJUAP//ncEw
Date: Fri, 17 Feb 2012 03:30:36 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB702C9DB@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
	 <1329439216.2892.36.camel@pasglop>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB702B97D@039-SN2MPN1-013.039d.mgd.msft.net>
 <1329448660.2892.42.camel@pasglop>
In-Reply-To: <1329448660.2892.42.camel@pasglop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1H3UovK029190

> -----Original Message-----
> From: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org]
> Sent: Friday, February 17, 2012 11:18 AM
> To: Liu Qiang-B32616
> Cc: jgarzik@pobox.com; linux-ide@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
> 
> On Fri, 2012-02-17 at 01:54 +0000, Liu Qiang-B32616 wrote:
> > The default will be set in a common interface
> > fsl_sata_set_irq_coalescing when initialize the controller. This
> > interface will check the range of intr count and ticks and make sure
> the values are reasonably.
> 
> Allright, but the current defaults are basically no coalescing right ?
> 
> > It's hard to find a aggressive value to adapt all scenarios, so I use
> > echo to adjust the value. I remember P5020 have some performance issue,
> I will check it.
> > BTW, which filesystem do you use? Ext2 is lower than ext4 because
> > metadata is continuously wrote to disk. You can try ext4 or xfs.
> 
> ext3 at the moment, I plan to switch to ext4 when I finish that fsck pass
> which is taking hours... I am not aware of the 5020 performance issues,
> is this something documented and/or fixable ?
> 

My patch may not meet your requirement:(
For your performance requirement, I suggest use ext4 filesystem and SSD.

Thanks.

> Cheers,
> Ben.
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
