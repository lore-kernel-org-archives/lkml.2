Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1ICOqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:46:48 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:55359 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1ICOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:46:46 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXULisfr6_EOrj8+q36UMo2mudcoJu3z0SX4T3x_OZQSg@mail.gmail.com>
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
Date: Sat, 3 Sep 2011 16:46:45 +0200
Message-ID: <CA+icZUWTS4fM9ZjEvjpPUsEzSdtKnF9yZPMpLwQmOGDL6Z9D_Q@mail.gmail.com>
Subject: Re: [next] unix stream crashes
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Yan, Zheng" <yanzheng@21cn.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Valdis.Kletnieks@vt.edu,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 3, 2011 at 3:47 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Sat, Sep 3, 2011 at 2:30 PM, Yan, Zheng <yanzheng@21cn.com> wrote:
>> The skb can be destructed before the while loop in unix_stream_sendmsg stops.
>> please try below patch.
>>
[...]
>
> I have tested your patch on i386 against:
>
> 1. linux-next/patch-v3.1-rc3-next-20110826
> 2. scm-fix/0001-Revert-Scm-Remove-unnecessary-pid-credential-referen.patch
> 3. scm-fix-2/scm_send.patch
> 4. scm-fix-3/0001-Fix-unix-stream-crashes.patch
>
> So the BROKEN scm-send path seems to be fixed, now!
>
[...]
> Doing now a 2nd run with:
>
> 1. linux-next/patch-v3.1-rc3-next-20110826
> 2. scm-fix-3/0001-Fix-unix-stream-crashes.patch
>

2nd run is fine, too.

- Sedat -
