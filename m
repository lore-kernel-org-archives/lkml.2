Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1EZHlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:41:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34402 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab1EZHlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:41:03 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Alexander Stein'" <alexander.stein@systec-electronic.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>,
        "'Fan, Yongning'" <yongning.fan@intel.com>
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105251409.47309.alexander.stein@systec-electronic.com> <F873CB63EEA24284982A8FA0F0B0F167@hacdom.okisemi.com> <201105260809.19425.alexander.stein@systec-electronic.com>
Subject: RE: pch_gpio: Support new device ML7223
Date: Thu, 26 May 2011 16:41:00 +0900
Message-ID: <B30B2D5133804152AC31FC1F8A6DDDF6@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: Acwba3eqb6ZNIkFzQTuuDAokuK4R1wADHyww
In-Reply-To: <201105260809.19425.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Alexander 

From: Alexander Stein [mailto:alexander.stein@systec-electronic.com] 
Sent: Thursday, May 26, 2011 3:09 PM

> I just meant to move 0x8803 from the line above into 
> pci_ids.h. It is unrelated to your patch.
> And if this _must_ be moved to pci_ids.h I'm the wrong person 
> to decide.

I understand.
I will move 0x8803 to pci_ids.h.
I will post 2 patches, one is patch for "8803", the other is patch for "ML7223".

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.



