Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1KRDQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:16:18 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:6391
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107Ab1KRDQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:16:16 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzc89bh542M1432Nzz1202hzzz2dh2a8h668h839h8e2h8e3h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sun york-R58495 <R58495@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMpIUnsb9+I0lR9k+0uRq1j4EoUpWwJ/0AgAAFb4CAAAQAAIAAAwAAgAAOBACAAAE+gIAAAP2AgAABnICAAX/yAIAAMKGg
Date: Fri, 18 Nov 2011 03:15:39 +0000
Message-ID: <3C06C26914DACA4BB3A368F78CA0B3A712BAB1@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	 <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	 <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	 <1321464509.7847.41.camel@oslab-l1>
	 <1321464968.2309.384.camel@groeck-laptop>
	 <1321466135.7847.55.camel@oslab-l1>
	 <20111116190954.67c846fc@endymion.delvare>
	 <1321467638.7847.73.camel@oslab-l1>
	 <20111116201048.4b7877dd@endymion.delvare>
	 <1321470915.7847.122.camel@oslab-l1>
	 <20111116201847.6b11dc7f@endymion.delvare>
	 <1321471473.7847.126.camel@oslab-l1> <1321553924.2730.7.camel@groeck-laptop>
In-Reply-To: <1321553924.2730.7.camel@groeck-laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.75]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAI3GUMt007805

I have tested this patch. It works on p1022ds platform.
Thanks.

Regards,
Yuantian

> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> Sent: 2011å¹´11æœˆ18æ—¥ 2:19
> To: sun york-R58495
> Cc: Jean Delvare; Tabi Timur-B04825; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org; Tang Yuantian-B29983
> Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> SMBUS_READ_BLOCK_DATA
> 
> If you look closely, you may realize that the mpc_read also doesn't
> validate of any of the other parameters. Are you going to request that
> such validations be added as well ? How about the other functions in this
> driver ? Should each function also validate each of its parameters ? If
> not, where do you draw the line ?
> 
> Besides, the caller is the SMBus block read function, which does know
> that SMBus block reads are limited to 32 bytes (plus length).
> 
> Guenter
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
