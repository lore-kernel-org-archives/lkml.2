Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab1IIMmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:42:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:2006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab1IIMmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="46764723"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 9 Sep 2011 18:12:03 +0530
Subject: RE: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: AcxutsuHIFxQhKFbQ++SV0k08OM85AALVjUQ
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C4317651@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
 <20110905105253.2787b91f@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
 <20110908021327.GA8890@zhy> <20110908072948.GB11124@zhy>
 <3CA6C6D9F70D314CA34352990B57DA1507C42C3CA5@bgsmsx502.gar.corp.intel.com>
 <20110909060725.GA21124@zhy>
In-Reply-To: <20110909060725.GA21124@zhy>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p89CgOKM031327

> > > > > Further investigation of this issue shows that the thread is in
> > > > > running state
> 
> Hmm, how do you detect it?
> 
> > > and it is not scheduled. I am not sure how I will go about debugging this
> issue.
> > > Any pointer would help.
> 
> Could 'cat /proc/sched_debug' give some useful info?
Tried. It did not help.
> 
> And BTW, have you tried CONFIG_DETECT_SOFTLOCKUP = y?
> 
It is already set. 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
