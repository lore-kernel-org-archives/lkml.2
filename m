Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab0JZJrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:47:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:32012 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758893Ab0JZJrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:47:40 -0400
Message-ID: <001c01cb74f2$d3dd8990$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Ralf Baechle" <ralf@linux-mips.org>, <linux-i2c@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
References: <4CC645A1.5010509@dsn.okisemi.com><20101026102048.316d0c04@endymion.delvare><001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com> <20101026111322.738b0b14@endymion.delvare>
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
Date: Tue, 26 Oct 2010 18:47:37 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tuesday, October 26, 2010 6:13 PM, Jean Delvare wrote:
> The _pch becomes redundant then, i2c-topcliff.c would be enough, but
> both are fine with me, as my initial concern is gone.
I agree.
I will modify to "i2c-topcliff.c".

> There's no Reviewed-by, Acked-by or Signed-off-by from anyone at Intel
> in the patch you posted. 
Must we get Intel's signature ? 
We have already got the following. Isn't  this enough ?
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>

Though I haven't heard like the requirement,
if Intel's signature is mandatory, I will request to Intel.

Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
