Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0HZVbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:31:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:22307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab0HZVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,276,1280732400"; 
   d="scan'208";a="600769720"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Thu, 26 Aug 2010 15:31:07 -0600
Subject: RE: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Topic: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Index: ActFQjBhUcK+NBu/TYWixB/CAsZAwQAIP6jg
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660082E9090@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <20100824094524.GA17608@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A136600821444B@rrsmsx501.amr.corp.intel.com>
 <20100826112732.GA15559@torres.zugschlus.de>
 <20100826171442.GA22941@torres.zugschlus.de>
In-Reply-To: <20100826171442.GA22941@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7QLVHQ3009998

Marc Haber wrote:
> On Thu, Aug 26, 2010 at 01:27:32PM +0200, Marc Haber wrote:
>> On Wed, Aug 25, 2010 at 12:01:40PM -0600, Tantilov, Emil S wrote:
>>> We have a tool that you can use to dump the registers from the port
>>> in the failed state:
>>> http://sourceforge.net/projects/e1000/files/Ethregs%20-%20Register%20Dump%20Tool/ethregs-1.12.3/
>> 
>> Attached, for an interface in the working state. I'll deliver another
>> regdump when I see the issue again
> 
> Here we go, with a non-working interface.

After reviewing the output from dmidecode I determined that your model T60 is slightly different than mine. It appears that you have the widescreen version. Is that correct?

Also you seem to be running a fairly old version of the BIOS (1.08). The latest is 1.18:
http://www-307.ibm.com/pc/support/site.wss/MIGR-67020.html

I would recommend that you upgrade your BIOS. If that does not help we can continue with the investigation. I will also try to locate a widescreen T60 that would hopefully help me with the repro. 

The model I have has been running all kinds of stress since you first reported this issue, and so far is rock solid.

> 
> Greetings
> Marc


Thanks,
Emilÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
