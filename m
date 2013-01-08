Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3AIHdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:33:50 -0500
Received: from smtp.nokia.com ([147.243.128.25]:35827 "EHLO mgw-da03.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab3AIHdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:33:49 -0500
X-Greylist: delayed 84683 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 02:33:44 EST
From: <leonid.moiseichuk@nokia.com>
To: <anton.vorontsov@linaro.org>, <kamezawa.hiroyu@jp.fujitsu.com>
CC: <rientjes@google.com>, <penberg@kernel.org>, <mgorman@suse.de>,
        <glommer@parallels.com>, <mhocko@suse.cz>, <kirill@shutemov.name>,
        <lcapitulino@redhat.com>, <akpm@linux-foundation.org>,
        <gthelen@google.com>, <kosaki.motohiro@gmail.com>,
        <minchan@kernel.org>, <b.zolnierkie@samsung.com>,
        <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: RE: [PATCH 1/2] Add mempressure cgroup
Thread-Topic: [PATCH 1/2] Add mempressure cgroup
Thread-Index: AQHN6lYfaY+czq0v9ECWXu6+DqtfFpg9k8UAgAF7X4CAAAOIEA==
Date: Tue, 8 Jan 2013 07:57:25 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269046C33F0@008-AM1MPN1-003.mgdnok.nokia.com>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
 <50EA8CA2.7020608@jp.fujitsu.com>
 <20130108072935.GA15431@lizard.gateway.2wire.net>
In-Reply-To: <20130108072935.GA15431@lizard.gateway.2wire.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.194.134]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jan 2013 07:57:26.0408 (UTC) FILETIME=[CCA73880:01CDED75]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r097XoUq004865

-----Original Message-----
From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org] 
Sent: 08 January, 2013 08:30
...
> > +static const uint vmpressure_level_med = 60;
> > +static const uint vmpressure_level_oom = 99;
> > +static const uint vmpressure_level_oom_prio = 4;
> > +
..
Seems vmpressure_level_oom = 99 is quite high if I understand it as a global. If I do not wrong in old version of kernel the kernel only memory border was stated as 1/32 part of available memory meaning no allocation for user-space if amount of free memory reached 1/32. So, decreasing this parameter to 95 or 90 will allow notification to be propagated to user-space and handled.

Best wishes,
Leonid
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
