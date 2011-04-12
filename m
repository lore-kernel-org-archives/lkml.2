Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1DLTZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:25:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56544 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab1DLTZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RbC/ulEGa1T3nwuXTCVZt+3I5kLgr3fH0697OVOPbOCgt1uQuUPHWKMWBdS1Juf8ts
         t563gYKUuHAc329RAMAGVF8qO8xtTafcP/XK/TrbxYEWhfpXXOc6yy8lbJ8OeuoXWkzD
         5mnVGq+MaJ7nErQTGys/TcwQL9NKIdpjzWA8s=
MIME-Version: 1.0
In-Reply-To: <20110412105827.443bd56e@jbarnes-desktop>
References: <4D90CBE5.6090706@kernel.org>
	<20110412091145.2bc5e6a9@jbarnes-desktop>
	<4DA489F0.4000003@kernel.org>
	<20110412104716.5388849d@jbarnes-desktop>
	<4DA491C6.90403@kernel.org>
	<20110412105827.443bd56e@jbarnes-desktop>
Date: Tue, 12 Apr 2011 12:25:31 -0700
X-Google-Sender-Auth: QKjUWL9M_er83ckjAU2eH1-2Z1Y
Message-ID: <BANLkTik0WzoBig5tfefkEEaWc-xaXQDq9Q@mail.gmail.com>
Subject: Re: [PATCH -v2] x86: Remove dma32_reserve_bootmem
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:58 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 12 Apr 2011 10:54:14 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On 04/12/2011 10:47 AM, Jesse Barnes wrote:
>> > On Tue, 12 Apr 2011 10:20:48 -0700
>> > Yinghai Lu<yinghai@kernel.org>  wrote:
>> >
>> >>
>> >> That is workaround for holding dma32 buf when early bootmem could use up
>> >> those range on system that have lots of RAM.
>> >>
>> >> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
>> >>
>> >> So We could remove those not needed code now.
>> >>
>> >> -v2: rebase on pci-next
>> >>
>> >> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>> >>
>> >
>> > Hm, still didn't apply cleanly, I guess the patch got corrupted.  I
>> > fixed it up by hand and applied to linux-next though, thanks.
>>
>> sorry for that. looks like recent thunderbird upgrade convert TAB to space..
>
> Thanks for checking.  I wonder why every mailer (and some MTAs!) feel
> the need to molest message content so thoroughly...
>

looks like patchwork and LKML have tab instead of spaces.

https://patchwork.kernel.org/patch/701342/

https://lkml.org/lkml/2011/4/12/358

also it is very interesting: in thunderbox inbox/send box, some mails
are viewed with TAB as spaces.
but source does have TAB.

Yinghai


Yinghai
