Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0HZRWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:22:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:14778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0HZRWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,274,1280732400"; 
   d="scan'208";a="832166380"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Thu, 26 Aug 2010 11:22:45 -0600
Subject: RE: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Topic: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Index: ActFEbPykTd24L4zRLWiJRai1ubfwAAMUbrw
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660082E8C5B@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <20100824094524.GA17608@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A136600821444B@rrsmsx501.amr.corp.intel.com>
 <20100826112732.GA15559@torres.zugschlus.de>
In-Reply-To: <20100826112732.GA15559@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7QHN24R008898

>-----Original Message-----
>From: Marc Haber [mailto:mh+linux-kernel@zugschlus.de]
>Sent: Thursday, August 26, 2010 4:28 AM
>To: Tantilov, Emil S
>Cc: Linux Kernel Developers; Linux Kernel Network Developers; e1000-
>devel@lists.sourceforge.net
>Subject: Re: No link on e1000e with 2.6.35.3 and ThinkPad T60
>
>On Wed, Aug 25, 2010 at 12:01:40PM -0600, Tantilov, Emil S wrote:
>> Marc Haber wrote:
>> > On Sat, Jul 24, 2010 at 11:26:44AM +0200, Marc Haber wrote:
>> >> Additionally, sometimes, probably after suspend/resume, the wired
>> >> ethernet does not come up properly again, ip addr claims "NO CARRIER"
>> >> even if the LEDs on the interface and on the switch claim that there
>> >> was a link. No packets are received by the interface when it's at
>> >> this stage.
>> >
>> > As of 2.6.35.3, this issue has become worse. It now even happens
>> > directly after freshly booting the system that I cannot get a link on
>> > the wired ethernet.
>> >
>> > What information do you need to find out what's going on there?
>>
>> Can you please post the output of dmidecode?
>
>Attached.
>
>> We have a tool that you can use to dump the registers from the port in
>the failed state:
>> http://sourceforge.net/projects/e1000/files/Ethregs%20-
>%20Register%20Dump%20Tool/ethregs-1.12.3/
>
>Attached, for an interface in the working state. I'll deliver another
>regdump when I see the issue again.
>
>> I have not been able to reproduce any of the issues you reported on
>> T60 here in the lab, so we need to start looking into more details.
>>
>> Also, could you please file a bug at e1000.sf.net with all the
>> information you provided so far?
>
>Will do in the next days.
>
>I guess it would be better to file two bugs, one for the crashes and
>one for the no-link-in-some-situations issue, right? Or is it likely
>that they both have the same cause?

If you feel like the issues are unrelated then file 2 bugs. 

As far as the crashes go - it would help a lot if you can get a trace.
You can use a serial console if you have a docking station for the T60.

Also make sure to include all the information you provided so far in the bugs.

Thanks,
Emil


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
