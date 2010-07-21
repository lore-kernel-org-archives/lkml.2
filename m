Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab0GUJXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:23:43 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50912 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab0GUJXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:23:39 -0400
From: <ext-phil.2.carmody@nokia.com>
To: <dmitry.torokhov@gmail.com>, <daniel@caiaq.de>
CC: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Date: Wed, 21 Jul 2010 11:22:35 +0200
Subject: RE: [PATCH 4/4] input: dynamically allocate ABS information
Thread-Topic: [PATCH 4/4] input: dynamically allocate ABS information
Thread-Index: Acsor2WLTs+GyA+USqK5glzoOLXNqAABtvwu
Message-ID: <702744BC498BAE41B3AA631D95EC463058B3CFD798@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
 <20100721083150.GB21558@core.coreip.homeip.net>,<20100721083216.GC21558@core.coreip.homeip.net>
In-Reply-To: <20100721083216.GC21558@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Jul 2010 09:23:27.0292 (UTC) FILETIME=[602D1FC0:01CB28B6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tiny tiny nit...

From: Dmitry Torokhov [dmitry.torokhov@gmail.com]
...
+void input_alloc_absinfo(struct input_dev *dev)
+{
+       if (!dev->absinfo)
+               dev->absinfo = kcalloc(ABS_CNT, sizeof(struct input_absinfo),
+                                       GFP_KERNEL);
+
+       WARN(!dev->absinfo, "%s(): kzalloc() failed?\n", __func__);

kcalloc failed, not kzalloc.

Phil
