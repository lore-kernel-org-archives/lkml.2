Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1AKJmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:42:21 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31597 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971Ab1AKJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:42:14 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Milton Miller'" <miltonm@bga.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>,
        "'Wang, Qi'" <qi.wang@intel.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com><20101229064937.GC8172@angua.secretlab.ca><280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com><20110105163835.GD17272@angua.secretlab.ca><46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com> <topcliff-split@mdm.bga.com> 
Subject: RE: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Date: Tue, 11 Jan 2011 18:42:11 +0900
Message-ID: <CA1F4AF27C0D466BA059E4B050FF3360@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: 
Thread-Index: AcuuTF63DADl1Jf1TeW6DYK5JWPNRgDJS+zAAAB3ltA=
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend
(Previous destination address is broken partly.)

Hi Grant,

On Friday, January 07, 2011 6:22 PM, Milton Miller wrote:
> follow mfd_add_devices into drivers/mfd/mfd-core.c
I have also seen mfd-core.c.
However, I couldn't clear my question.

Q1. It seems platform_device is not used in your example. 
	Does need "platform_device" ?
Q2. How detect pch_spi channel dynamically ?

I want to catch your saying correctly.
Could you give me more information ?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

