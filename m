Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1ICPiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 11:38:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43991 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1ICPiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 11:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUWTS4fM9ZjEvjpPUsEzSdtKnF9yZPMpLwQmOGDL6Z9D_Q@mail.gmail.com>
References: <4E5FEF28.60406@gmail.com>
	<3179.1314924559@turing-police.cc.vt.edu>
	<1314927645.2576.2939.camel@schen9-DESK>
	<6805.1314979936@turing-police.cc.vt.edu>
	<1315007703.2576.2965.camel@schen9-DESK>
	<6043.1315028115@turing-police.cc.vt.edu>
	<CA+icZUVuJWpLquLk4kHJzmMKtPw24oxud=u3Na0U0HhSYqwV1w@mail.gmail.com>
	<4E61C7F2.3090902@gmail.com>
	<CAAM7YAkB3VVNMmBMVuvEZuV6oGZeyog37_sjFGUunu+15apvZA@mail.gmail.com>
	<CA+icZUXULisfr6_EOrj8+q36UMo2mudcoJu3z0SX4T3x_OZQSg@mail.gmail.com>
	<CA+icZUWTS4fM9ZjEvjpPUsEzSdtKnF9yZPMpLwQmOGDL6Z9D_Q@mail.gmail.com>
Date: Sat, 3 Sep 2011 23:38:20 +0800
X-Google-Sender-Auth: epvMKspJIo5lHjJ75-0hwAo5jYQ
Message-ID: <CAAM7YAkZpuh2ReCmQFGObDLixgF28OsBMq=BYXRP_QkU-9a0Uw@mail.gmail.com>
Subject: Re: [next] unix stream crashes
From: "Yan, Zheng " <yanzheng@21cn.com>
To: sedat.dilek@gmail.com
Cc: Jiri Slaby <jirislaby@gmail.com>, Valdis.Kletnieks@vt.edu,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 3, 2011 at 10:46 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Sat, Sep 3, 2011 at 3:47 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Sat, Sep 3, 2011 at 2:30 PM, Yan, Zheng <yanzheng@21cn.com> wrote:
>>> The skb can be destructed before the while loop in unix_stream_sendmsg stops.
>>> please try below patch.
>>>
> [...]
>>
>> I have tested your patch on i386 against:
>>
>> 1. linux-next/patch-v3.1-rc3-next-20110826
>> 2. scm-fix/0001-Revert-Scm-Remove-unnecessary-pid-credential-referen.patch
>> 3. scm-fix-2/scm_send.patch
>> 4. scm-fix-3/0001-Fix-unix-stream-crashes.patch
>>
>> So the BROKEN scm-send path seems to be fixed, now!
>>
> [...]
>> Doing now a 2nd run with:
>>
>> 1. linux-next/patch-v3.1-rc3-next-20110826
>> 2. scm-fix-3/0001-Fix-unix-stream-crashes.patch
>>
>
> 2nd run is fine, too.
>

Thank you, will send a new patch later.

> - Sedat -
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
