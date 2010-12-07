Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0LGAFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:05:40 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:23706 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab0LGAFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:05:39 -0500
Message-ID: <F707E6EFF9AF4169B5E0C55B5AB2757B@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Alan Cox" <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Ben Dooks" <ben-linux@fluff.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Feng Tang" <feng.tang@intel.com>,
        "Tobias Klauser" <tklauser@distanz.ch>, <yong.y.wang@intel.com>,
        <qi.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <andrew.chih.howe.khor@intel.com>
References: <4CE3281A.4050709@dsn.okisemi.com> <20101201012441.GA2907@kroah.com>
Subject: Re: Serial: EG20T: add PCH_UART driver
Date: Tue, 7 Dec 2010 09:05:34 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 01, 2010 10:24 AM, Greg KH wrote:
> I've applied this, but I now get the following warnings when building
> the code:

Sorry, for late.
I can't see these warnings.
I think we build with 32bit Linux PC.
But we don't have 64-bit PC.

I tried build with "-m64" option on our PC, I can see the following error.
: sorry, unimplemented: 64-bit mode not compiled in

Can I see the warnings using our PC ?
If you have any information, let me know how to do.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
