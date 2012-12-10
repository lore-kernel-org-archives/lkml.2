Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2LJPad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:30:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40538 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab2LJPac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:30:32 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121210105449.GC7264@gmail.com>
References: <50C56A13.9040604@linux.vnet.ibm.com> <50C591B0.10408@linux.vnet.ibm.com> <20121210105449.GC7264@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: TIP tree's master branch failed to boot up
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 10 Dec 2012 07:28:12 -0800
To: Ingo Molnar <mingo@kernel.org>, Michael Wang <wangyun@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <227554ec-58bc-4c8d-aaf7-b0c9073b6e18@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the current x86/microcode is broken, I have been trying to work with Fenghua on a fix but didn't get one before the weekend.

Ingo Molnar <mingo@kernel.org> wrote:

>
>I've Cc:-ed hpa, he merged the x86/microcode bits.
>
>Michael Wang, I've excluded x86/microcode from the latest 
>version of the -tip tree which I just pushed out:
>
>  4e00fd4c93e0 Merge branch 'x86/cleanups'
>
>Can you confirm that your server boots now?
>
>Thanks,
>
>	Ingo
>
>* Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
>
>> On 12/10/2012 12:50 PM, Michael Wang wrote:
>> > Hi, Folks
>> > 
>> > I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
>> > failed to boot up my server, it's hung at very beginning and I
>could not
>> > catch any useful log, is there any one else got this problem or I'm
>the
>> > only one?.
>> 
>> And bisect catch below commit:
>> 
>> commit 56e7dba100a50f674627a3764fd4da4a6ec93295
>> Merge: ea8432f 16544f8
>> Author: Ingo Molnar <mingo@kernel.org>
>> Date:   Fri Dec 7 12:13:11 2012 +0100
>> 
>>     Merge branch 'x86/microcode'
>> 
>> Regards,
>> Michael Wang
>> 
>> 
>> > 
>> > Regards,
>> > Michael Wang
>> > 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
