Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2GNPdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 11:33:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65054 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2GNPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzkx6e19Gj=vKj3yjW3Yjj3eBx1SbGkmdbTMK6WMtX5Bg@mail.gmail.com>
References: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
	<CAFLxGvzkx6e19Gj=vKj3yjW3Yjj3eBx1SbGkmdbTMK6WMtX5Bg@mail.gmail.com>
Date: Sat, 14 Jul 2012 21:18:04 +0545
Message-ID: <CAHdPZaM3Xq9=HLJztQe2hW7mxwatYeeUV7AKnCEr0xzpTJwQRg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010 on 3.5-rc6
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 8:07 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Sat, Jul 14, 2012 at 2:11 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>> 3.5-rc6 with git head at fdb1335a82e. (from Torvald's branch)
>
> CC'in futex guys...
>
>> dmesg:
>>
>> [43610.535421] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000010
>
> Is this the first error message in dmesg?
No its not. and i was doing a dmesg -c and run... thats bad i should
not be doing that..
> IOW no WARNING before the BUG?
yeah there were some warnings about the trinity.
>
> Looks like futex_wait_requeue_pi() was called before  pi_state->pi_mutex got
> initialized.
>

Let me reproduce it again... and i will report it with full dmesg again.
> --
> Thanks,
> //richard

Thanks,
Devendra.
