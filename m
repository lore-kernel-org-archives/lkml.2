Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1AGGr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:47:57 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6528 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231Ab1AGGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:47:56 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20101229064937.GC8172@angua.secretlab.ca> <280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com> <20110105163835.GD17272@angua.secretlab.ca>
Subject: RE: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Date: Fri, 7 Jan 2011 15:47:54 +0900
Message-ID: <EE7A481EBBBE4834A7A3CB4B329D898F@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acus9wTxGz7KrmkJRQuS/bs2aL5tZABP2hag
In-Reply-To: <20110105163835.GD17272@angua.secretlab.ca>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Sorry, I made mistake in my-mail address.
I sent again.

On Thursday, January 06, 2011 1:39 AM, Grant Likely wrote:
> As far as examples go, drivers/mfd/timberdale.c seems reasonable, if a 
> bit larger than what you need.

Thank you for your suggestion.
However, though seeing this driver, I didn't understand your intention.
It seems platform_device/platform_driver are not used in this.
Which part of this driver do you want to show me as reference ?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

