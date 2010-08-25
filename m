Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0HYSBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:01:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:20532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0HYSBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,269,1280732400"; 
   d="scan'208";a="548676599"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Wed, 25 Aug 2010 12:01:40 -0600
Subject: RE: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Topic: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Index: ActDcS1tGx6By2O0Rv2tuMyGDsdv6gBDMxVQ
Message-ID: <EA929A9653AAE14F841771FB1DE5A136600821444B@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <20100824094524.GA17608@torres.zugschlus.de>
In-Reply-To: <20100824094524.GA17608@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7PI21e5002787

Marc Haber wrote:
> Hi,
> 
> On Sat, Jul 24, 2010 at 11:26:44AM +0200, Marc Haber wrote:
>> Additionally, sometimes, probably after suspend/resume, the wired
>> ethernet does not come up properly again, ip addr claims "NO CARRIER"
>> even if the LEDs on the interface and on the switch claim that there
>> was a link. No packets are received by the interface when it's at
>> this stage.
> 
> As of 2.6.35.3, this issue has become worse. It now even happens
> directly after freshly booting the system that I cannot get a link on
> the wired ethernet.
> 
> What information do you need to find out what's going on there?

Can you please post the output of dmidecode?

We have a tool that you can use to dump the registers from the port in the failed state:
http://sourceforge.net/projects/e1000/files/Ethregs%20-%20Register%20Dump%20Tool/ethregs-1.12.3/

I have not been able to reproduce any of the issues you reported on T60 here in the lab, so we need to start looking into more details.

Also, could you please file a bug at e1000.sf.net with all the information you provided so far?

Thanks,
Emil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
