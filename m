Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2EBGuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:50:10 -0400
Received: from smtp.nokia.com ([147.243.128.26]:22463 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab2EBGuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:50:08 -0400
From: <leonid.moiseichuk@nokia.com>
To: <minchan@kernel.org>, <anton.vorontsov@linaro.org>
CC: <kosaki.motohiro@gmail.com>, <riel@redhat.com>, <penberg@kernel.org>,
        <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>,
        <glommer@parallels.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <suleiman@google.com>
Subject: RE: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
Thread-Topic: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
Thread-Index: AQHNJ50OlOBu3h1unUSJMtRzhrRpypa1SzSAgAA2yoCAABDDgIAAJKaAgAAZ0gCAADwvUA==
Date: Wed, 2 May 2012 06:46:15 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045D2AC9@008-AM1MPN1-003.mgdnok.nokia.com>
References: <20120418083208.GA24904@lizard> <20120418083523.GB31556@lizard>
 <alpine.LFD.2.02.1204182259580.11868@tux.localdomain>
 <20120418224629.GA22150@lizard>
 <alpine.LFD.2.02.1204190841290.1704@tux.localdomain>
 <20120419162923.GA26630@lizard> <20120501131806.GA22249@lizard>
 <4FA04FD5.6010900@redhat.com> <20120502002026.GA3334@lizard>
 <4FA08BDB.1070009@gmail.com> <20120502033136.GA14740@lizard>
 <4FA0C042.9010907@kernel.org>
In-Reply-To: <4FA0C042.9010907@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.82.242]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 02 May 2012 06:46:16.0193 (UTC) FILETIME=[45B8DF10:01CD282F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q426oQ6a018898

> -----Original Message-----
> From: ext Minchan Kim [mailto:minchan@kernel.org]
> Sent: 02 May, 2012 08:04
> To: Anton Vorontsov
> Cc: KOSAKI Motohiro; Rik van Riel; Pekka Enberg; Moiseichuk Leonid (Nokia-
...
> I think hardest problem in low mem notification is how to define _lowmem
> situation_.
> We all guys (server, desktop and embedded) should reach a conclusion on
> define lowmem situation before progressing further implementation
> because each part can require different limits.
> Hopefully, I want it.
> 
> What is the best situation we can call it as "low memory"?

That depends on what user-space can do. In n9 case [1] we can handle some OOM/slowness-prevention and actions e.g. close background applications, stop prestarted apps, 
flush browser/graphics caches in applications and do all the things kernel even don't know about. This set of activities usually comes as memory management design.

>From another side, polling by re-scan vmstat data using procfs might be performance heavy and for sure - use-time disaster.

Leonid
[1] http://maemo.gitorious.org/maemo-tools/libmemnotify - yes, not ideal but it works and quite well isolated code.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
