Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1ELMBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:01:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:48023 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab1ELMBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:01:06 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Thu, 12 May 2011 21:01:04 +0900
Message-ID: <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4DCAE163.2050602@metafoo.de>
Thread-Index: AcwQEIL8P0V3oljIRJ6wdVExyUuARAAiwC2w
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Lars, Grant

According to "/proc/interrupts", IRQ18 is not empty.
However, irq_alloc_descs returns "18".
I suspect irq_alloc_descs returns should not return "18".

> Grant,
Let me know your opinion.

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
> Sent: Thursday, May 12, 2011 4:20 AM
> To: Tomoya MORINAGA
> Cc: 'Grant Likely'; linux-kernel@vger.kernel.org; 
> toshiharu-linux@dsn.okisemi.com
> Subject: Re: Question: GPIO driver how to get irq_base
> 
> On 05/09/2011 10:54 PM, Tomoya MORINAGA wrote:
> > Hi Lars,
> > 
> > Did you see this email ?
> > I'm waiting for your response.
> > 
> 
> Hi
> 
> Well, it looks as if io-apic assumes that IRQ18 is reserved 
> for itself, while it actually is requested by your driver. 
> But that's all I can say. I'm not familiar with the x86 irq 
> code, so I've no idea what the proper fix would be.
> 
> - Lars
> 

