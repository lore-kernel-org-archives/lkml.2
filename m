Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2ILNiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:38:10 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:50112 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2ILNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:38:08 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [Resend][PATCH V3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [Resend][PATCH V3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac2CDARLx46d4YhzRzCtj3bjUVsV0QObXStgABFrVwAACxOGcA==
Date: Wed, 12 Sep 2012 13:37:20 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41384FC7F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41384F5FD@USINDEM103.corp.hds.com>
 <50500D04.6030907@zytor.com>
In-Reply-To: <50500D04.6030907@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-12_04:2012-09-12,2012-09-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1209120114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8CDcFqt029433

Hi,

I will submit some performance testing result.

Thanks!

Seiji

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Wednesday, September 12, 2012 12:18 AM
> To: Seiji Aguchi
> Cc: Thomas Gleixner (tglx@linutronix.de); linux-kernel@vger.kernel.org; rostedt@goodmis.org; 'mingo@elte.hu' (mingo@elte.hu);
> x86@kernel.org; dle-develop@lists.sourceforge.net; Satoru Moriya
> Subject: Re: [Resend][PATCH V3] trace,x86: add x86 irq vector tracepoints
> 
> On 09/11/2012 05:00 PM, Seiji Aguchi wrote:
> > Thomas,
> >
> > Please review my patch as we talked in Plumbers.
> >
> 
> Is there any measurable latency added here?  These are some of the most
> performance- (or at least latency-)critical paths in the kernel.
> 
> 	-hpa
> 
> --
> H. Peter Anvin, Intel Open Source Technology Center I work for Intel.  I don't speak on their behalf.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
