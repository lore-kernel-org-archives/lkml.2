Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1GYPYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:24:43 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:38358 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1GYPYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D8858.8000900@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:14:32 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Malte Starostik <m-starostik@versanet.de>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 00/10] lis3: various fixes and enhancements
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here are a couple of patches from my backlog for the lis3. Since the 
move out of hwmon, I'm not entirely sure to who I should send the 
patches for the part which lies in driver/misc. Maybe Andrew can pick 
them, or should I send them directly to Linus?

Patch 1 avoids crashes with a buggy hardware (which is actually seen in 
the wild). Patch 7 fixes a missing free(). The rest of the patches are 
more enhancements. Iilka had actually sent another patch, coming as 
number 11, to allow multiple devices at the same time. But Cascardo 
noticed that it can cause problems with the misc device, so I'm not 
including it. Iilka, maybe have you found a solution since then?

Cheers,
Éric

