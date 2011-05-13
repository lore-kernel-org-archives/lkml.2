Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1EMCkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:40:17 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:28918 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab1EMCkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:40:15 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de> <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com> <4DCC384B.1020202@metafoo.de>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Fri, 13 May 2011 11:40:12 +0900
Message-ID: <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwQ3Ozi4W4M80mPS5atKU61QIhB4wAOR+Gw
In-Reply-To: <4DCC384B.1020202@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Lars,

On Friday, May 13, 2011 4:43 AM, Lars-Peter Clausen wrote:
> Is it already used at the time when you call irq_alloc_descs?

Since gpio driver with interrupt function must be integrated as built-in,
I don't know whether "18" is already used or NOT at that time.
If you have any information, let me know.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

