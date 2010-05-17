Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0EQTKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:10:19 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:37803 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299Ab0EQTKR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:10:17 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 May 2010 21:09:50 +0200
Subject: PrimeCell interface
Thread-Topic: PrimeCell interface
Thread-Index: AcrxKnmIkhMxXInkSCic0X1d/8I8TwEyIezw
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A72621C@EXDCVYMBSTM006.EQ1STM.local>
References: <1272848076-28315-1-git-send-email-linus.walleij@stericsson.com>
	 <AANLkTinAVhnpjgVTtbZYYKb1t_DInVwTKkkJRzcO97RX@mail.gmail.com>
 <AANLkTim7Tp8lCwMbQwW5QiQ49j7idFFUWdU3x8azIlok@mail.gmail.com>
In-Reply-To: <AANLkTim7Tp8lCwMbQwW5QiQ49j7idFFUWdU3x8azIlok@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan, I think you'd better back out/revert the PrimeCell patches
from your next branch for the time being, i.e. these commits:

ARM: add generic PrimeCell interface to DMA40 v1
ARM: define the PrimeCell DMA API v5

Russell don't want that merged before we can also do it on
the Versatile, and while I'm already far up that road it will
also involve switching to the ioctl()-like API and that
is easier done with a separate patch for that and then
new PrimeCell patches.

Instead, please cherry-pick the DMA40 bug fixes I sent off
earlier, two patches from the latest patch set named:

DMAENGINE: DMA40 bug when checking paused status
DMAENGINE: DMA40 fix for allocation of logical channels

Also the platform data for DMA40 would be nice to feed in
once you have synced in Russells ARM tree.

Yours,
Linus Walleij
