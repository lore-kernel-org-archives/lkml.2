Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1IHJps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:45:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:14192 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112Ab1IHJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:45:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="49221165"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Sep 2011 15:15:38 +0530
Subject: RE: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: Acxt+SgsISm0VVLbQEyeekx+YIYpYwAEsP7g
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C42C3CA5@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
 <20110905105253.2787b91f@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
 <20110908021327.GA8890@zhy> <20110908072948.GB11124@zhy>
In-Reply-To: <20110908072948.GB11124@zhy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p889jtYZ025041

> > > Further investigation of this issue shows that the thread is in running state
> and it is not scheduled. I am not sure how I will go about debugging this issue.
> Any pointer would help.
> >
> > Could you confirm if [commit f26f9af Sched: fix skip_clock_update
> > optimization] residents in your kernel?
I applied this patch manually. I still see the issue.
> 
> And commit da7a735e51f9622eb3e1672594d4a41da01d7e4f
> http://marc.info/?l=linux-kernel&m=129527509622696&w=2
This is already applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
