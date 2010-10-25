Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0JYGK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:10:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:58635 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0JYGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:10:57 -0400
From: <samu.p.onkalo@nokia.com>
To: <eric.piel@tremplin-utc.net>, <jic23@cam.ac.uk>
CC: <khali@linux-fr.org>, <guenter.roeck@ericsson.com>,
        <lm-sensors@lm-sensors.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 25 Oct 2010 08:10:01 +0200
Subject: RE: [PATCH 00/12] lis3 accelerator feature update
Thread-Topic: [PATCH 00/12] lis3 accelerator feature update
Thread-Index: ActzjO+dsoYGQ9gcTtalcCNcLGzYjwAfiV9Q
Message-ID: <62697B07E9803846BC582181BD6FB6B836EAE847F1@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
 <4CC44B3D.5030404@tremplin-utc.net>
In-Reply-To: <4CC44B3D.5030404@tremplin-utc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Oct 2010 06:10:04.0458 (UTC) FILETIME=[440128A0:01CB740B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9P6BAl4000848

>-----Original Message-----
>From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
>owner@vger.kernel.org] On Behalf Of ext Ã‰ric Piel
>
>Op 22-10-10 13:57, Samu Onkalo schreef:
>> Changes are tested only with I2C interface using 8bit sensor since I
>don't
>> have other possibilities. Some features are not enabled
>> by default since I can't test them with all possible configurations.
>> Platform data contains field which controls new features.
>Thanks Samu for persevering with the automatic power down feature.
>Hopefully I'll find also some time to activate it on the hp_accel side.
>
>For now, I've reviewed the changes and everything looked fine, as well
>as tested them on my HP laptop (with a 12 bits sensor). Although most of
>the changes are not visible on this platform, at least there shouldn't
>be any regression.
>

Thanks for the review.

-Samu
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
