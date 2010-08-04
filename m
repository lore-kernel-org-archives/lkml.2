Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0HDSX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:23:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:19464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab0HDSXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:23:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,316,1278313200"; 
   d="scan'208";a="824724520"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>
Date: Wed, 4 Aug 2010 12:23:45 -0600
Subject: RE: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Topic: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Index: Acsv5neFDRfA+AKjS2mwEAEMpQ9XVwEGwbVA
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660024083FE@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A1366000F42E28@rrsmsx501.amr.corp.intel.com>
 <20100730125452.GA21444@torres.zugschlus.de>
In-Reply-To: <20100730125452.GA21444@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o74IOPSF006443

Marc Haber wrote:
> Hi,
> 
> On Tue, Jul 27, 2010 at 06:33:49PM -0600, Tantilov, Emil S wrote:
>> Marc Haber wrote:
>>> I have a new notebook, a Thinkpad T60, which is freezing in random
>>> intervals (like 30 minutes to two days) as long as I am using the
>>> on-board wired ethernet interface, which is an e1000e, [8086:109a].
>>> As long as I keep using the WLAN, the system runs for weeks despite
>>> frequent suspend/resume cycles etc. The crashes seem really to be
>>> tied to using the wired ethernet. This is a hard freeze, with
>>> nothing happening on the system, only a long push on the power
>>> button helps. 
>> 
>> When the crashes occur - is there a trace on the screen?
> 
> Not that I can see any. I'm working in X11, and the screen simply
> freezes. Mouse doesn't move any more, clock stops. System is not
> pingable, does not react to Ctrl-Alt-Bksp nor to any Magic Sysrq, nor
> does it shut down when I have the power button issue an acpi shutdown
> event.
> 
>> Do you know of a way to reproduce the issue? For example were
>> you downloading files, browsing internet, or using the ethernet
>> device in any way when the system crashed?
> 
> Sadly, no. I have it happen when typing in a remote ssh session, while
> on the other hand hundreds of megabytes can be downloaded just fine.
> It just happens "at random", two or three times a day. I have resorted
> to using the WLAN instead of the wired ethernet, but that's not a
> long-term solution.
> 
>>> Full dmesg and lspci-nn attached, please say if you need more.
>> 
>> Doesn't seem that there were any attachments to this email.
> 
> I forgot, sorry.
> 
>> Could you also provide the kernel config?
> 
> Attached as well.

I have a T60 running with 2.6.34.1 using your config and so far no issues. 

Looking at your lspci output - your system has a slightly different HW, but I don't know if this is significant.

Are you loading the kernel with any parameters (cat /proc/cmdline)?

Do you have firewall configured (iptables -L)?

Also now that 2.6.35 is out - could you give it a try and see if the situation had improved?

> 
> Greetings
> Marc

Thanks,
Emil

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
