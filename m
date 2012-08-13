Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2HMU4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:56:30 -0400
Received: from 209.248.170.90.nw.nuvox.net ([209.248.170.90]:45037 "EHLO
	GVL-MAIL.koe-americas.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753383Ab2HMU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:56:28 -0400
From: David Cullen <David.Cullen@koe-americas.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Fix "/usr/bin/xargs: rm: Argument list too long"
 during make distclean
Thread-Topic: [PATCH RFC] Fix "/usr/bin/xargs: rm: Argument list too long"
 during make distclean
Thread-Index: AQHNeYtJ0vuHTHXr8kOIY+yAGwirYZdYdyAAgAAFDAA=
Date: Mon, 13 Aug 2012 20:56:26 +0000
Message-ID: <502969FA.6010907@koe-americas.com>
References: <502957D5.1070800@koe-americas.com> <502965BE.3070406@zytor.com>
In-Reply-To: <502965BE.3070406@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
x-originating-ip: [10.1.5.27]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CC3FF42B1C28E4B9C669AE2958B135C@koe-americas.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7DKufKi011877

On 8/13/2012 4:38 PM, H. Peter Anvin wrote:
> On 08/13/2012 12:39 PM, David Cullen wrote:
>> When running "make distclean" in a cross chroot environment, the
>> following messages are emitted:
>>
>>     [user@host:/home/work/linux]: make distclean
>>     /usr/bin/xargs: rm: Argument list too long
>>     make: *** [clean] Error 126
>>
> 
> That sounds like a bug in xargs...
> 
> 	-hpa
> 

In my specific case, qemu-arm-static calls xargs (In fact, in my
cross chroot, qemu-arm-static is used to run every user mode process).

Do you mean that qemu-arm-static is exposing a latent defect in xargs?

Does qemu-arm-static steal some of the command line space that would
normally be available for xargs? If so, how would xargs figure out
this was happening and handle the problem?

-- 
Thank you,
David Cullenÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
