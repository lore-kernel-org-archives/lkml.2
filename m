Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0FGHyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:54:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33298 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab0FGHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:54:06 -0400
Message-ID: <000d01cb0616$99f3a5c0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C08D268.6000404@dsn.okisemi.com> <20100604130050.2b555944@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Mon, 7 Jun 2010 16:53:59 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

Thank you for your comment.
We are now modifying.
We will resubmit as soon as we can possible.

Thanks.
----- Original Message ----- 
From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "Andrew" <andrew.chih.howe.khor@intel.com>; "Intel OTC"
<joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>
Sent: Friday, June 04, 2010 9:00 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> > +/*!
> > + * @ingroup PHUB_PCILayerAPI
> > + * @fn static void __exit pch_phub_pci_exit(void)
> > + * @brief Provides the functionality of exiting the module
> > + * */
>
> Can we please do something about all this stuff first so the code is
> easier to review by those not familiar with the kernel format.
>
> I sent a bit of code out last time that did most of the work
>
> Alan
>



