Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1EMFmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:42:46 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47184 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab1EMFmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:42:45 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de> <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com> <4DCC384B.1020202@metafoo.de> <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com> <4DCCA317.2030302@metafoo.de>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Fri, 13 May 2011 14:42:42 +0900
Message-ID: <A9DC7D6B9E604C0BB5B3B2E271273043@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwRHItBN20Rb4i8QSKgUhat4UZQ/gAEVnMw
In-Reply-To: <4DCCA317.2030302@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friday, May 13, 2011 12:19 PM,  Lars-Peter Clausen wrote:
> Well, you should be able to figure that out with some debug 
> printks, shouldn't you?
I can confirm "18" is not assigned at that time.
After loading gpio driver, other modules are assigned to "IRQ18".
(IRQ numbers shared system)

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
> Sent: Friday, May 13, 2011 12:19 PM
> To: Tomoya MORINAGA
> Cc: 'Grant Likely'; linux-kernel@vger.kernel.org; 
> toshiharu-linux@dsn.okisemi.com
> Subject: Re: Question: GPIO driver how to get irq_base
> 
> On 05/12/2011 07:40 PM, Tomoya MORINAGA wrote:
> > Hi  Lars,
> > 
> > On Friday, May 13, 2011 4:43 AM, Lars-Peter Clausen wrote:
> >> Is it already used at the time when you call irq_alloc_descs?
> > 
> > Since gpio driver with interrupt function must be integrated as 
> > built-in, I don't know whether "18" is already used or NOT 
> at that time.
> > If you have any information, let me know.
> > 
> 
> Well, you should be able to figure that out with some debug 
> printks, shouldn't you?
> 
> - Lars
> 

