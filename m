Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1DROJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:09:45 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58093 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1DROJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:39 -0400
X-ASG-Debug-ID: 1303135778-082b70490001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
X-ASG-Orig-Subj: [PATCH v2 00/14] Update 88pm860x and max8925 MFD driver
Subject: [PATCH v2 00/14] Update 88pm860x and max8925 MFD driver
Date: Mon, 18 Apr 2011 22:03:57 +0800
X-ASG-Orig-Subj: [PATCH v2 00/14] Update 88pm860x and max8925 MFD driver
Message-Id: <1303135451-26362-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135778
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
v2:
	1. Fix the calculation issue on time in touch driver of 88pm860x.
	2. Always checking return code in open() of touch driver of 88pm860x.
	3. Avoid to check constraint name in regulator driver. Check
	driver_data instead.


