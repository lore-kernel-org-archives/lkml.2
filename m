Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0IZUUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:20:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60696 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0IZUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:20:47 -0400
X-User-Agent: K-9 Mail for Android
References: <20100827213629.GA11342@osdn.org.ua> <20100923165022.6982ffc1.akpm@linux-foundation.org> <20100926115354.GA30247@osdn.org.ua> <AANLkTiniAprv-rz0QQD540g7S1jbj8Na+e78Ro2R8Koa@mail.gmail.com>
In-Reply-To: <AANLkTiniAprv-rz0QQD540g7S1jbj8Na+e78Ro2R8Koa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: fs hang in 2.6.27.y | Fwd: [Bug 15658] New: [PATCH] x86 constant_test_bit() prone to misoptimization with gcc-4.4
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 26 Sep 2010 13:19:27 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
        Alexander Chumachenko <ledest@gmail.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Message-ID: <9772c472-dcf0-4e53-966d-569f1179eb17@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll check it when I get back home this evening and assuming it's Ok will push it to you.

"Linus Torvalds" <torvalds@linux-foundation.org> wrote:

>On Sun, Sep 26, 2010 at 4:53 AM, Michael Shigorin <mike@osdn.org.ua> wrote:
>>
>> The simplicity of adding that somewhat went over my head --
>> please find attached the corrected original patch against HEAD
>> with Signed-off-by: for both of us.  led@ didn't change cosmetics
>> -- thanks for providing it anyways.
>
>Ok, I think this patch is probably the right thing to do at this stage
>- and we should think about trying to see if we can improve code
>generation later.
>
>So: "Acked-by: Linus Torvalds <torvalds@linux-foundation.org>"
>
>Ingo/Thomas/Peter - I can take this either from the x86 tree, or
>directly. Just let me know. Or do you have any alternate suggestions
>that would be appropriate?
>
>                           Linus
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
