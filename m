Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1DVAdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:33:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14300 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab1DVAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:33:06 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Fri, 22 Apr 2011 09:33:03 +0900
Message-ID: <C0A959D4238142B6AFB2F3C43CEFC7E0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <20110421142422.GC32725@ponder.secretlab.ca>
Thread-Index: AcwAL++Wzb/0BazWToqDvM5Zkn5jZQAUXwsg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Lars-Peter Clausen

Thank you for your information.

It seems nothing driver uses irq_alloc_descs.
Thus, let me clarify my using.

int irq_base = irq_alloc_descs(-1, 0, 12, GFP_KERNEL)
(Intel-ET20T-PCH has GPIO~GPIO11)

Using the above, I can see "irq_base = 18d".
Is the above TRUE ?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

