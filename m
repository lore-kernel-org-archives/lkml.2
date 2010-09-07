Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0IGTPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:15:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:40246 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab0IGTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:15:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,329,1280732400"; 
   d="scan'208";a="835615521"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Tue, 7 Sep 2010 13:15:09 -0600
Subject: RE: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Topic: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Index: ActL+z6HNKv0Bo81QSC7duV/FRKtKQCxHJOA
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660085FFA51@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <20100824094524.GA17608@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A136600821444B@rrsmsx501.amr.corp.intel.com>
 <20100826112732.GA15559@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A13660082E8C5B@rrsmsx501.amr.corp.intel.com>
 <20100904063433.GB18734@torres.zugschlus.de>
In-Reply-To: <20100904063433.GB18734@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o87JFH30008515

Marc Haber wrote:
> Hi,
> 
> On Thu, Aug 26, 2010 at 11:22:45AM -0600, Tantilov, Emil S wrote:
>> As far as the crashes go - it would help a lot if you can get a
>> trace. You can use a serial console if you have a docking station
>> for the T60. 
> 
> I have indeed recently bought a docking station. How do I obtain a
> trace from a frozen sysem?

The idea is to catch any output that may be pertinent to the crash. With some luck the hang would be associated with a trace which you can record by using a serial console. 

Check out the serial-console.txt file for more info in the Documentation section of the kernel source. Once you have your primary system configured you can connect via serial cable to a secondary system with minicom (or other terminal that can read from serial port) to be able to capture the trace.

> 
> Greetings
> Marc

Thanks,
Emil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
