Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0FGF6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:58:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59650 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0FGF6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UKuygU3WVGjdfV0ziVk2n4hhyWIBR5Zd9nq44CnpLWEz8LWHY7BfLnhGe6a49gN83p
         lAztNOrtGvG34ZPfUz2aW8gZTJSUHCa3hPQzBbu4jqcc8f/nsc0nWwiqShqjkB+t4wt4
         q/YqfNf9h7cdLv2n9htXzDk6Gt+JEVnQ+2CUE=
MIME-Version: 1.0
In-Reply-To: <AANLkTilAzIGdPGnZfi0y5fUpJm_J9pO_ns2cZhSFfMWh@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
	<AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
	<AANLkTilAzIGdPGnZfi0y5fUpJm_J9pO_ns2cZhSFfMWh@mail.gmail.com>
Date: Mon, 7 Jun 2010 07:58:49 +0200
Message-ID: <AANLkTikK7emo7Q7pUrFtcOSzXs88PAwhElvqZdLzsoy3@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 5:01 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 10:33 AM, Dave Airlie <airlied@gmail.com> wrote:
>> Just an initial guess does the vt.c patch in thread
>>
>> "Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)"

I will try it later today.

And Jeff also has this 0720-pattern:
> 2010-06-06T22:09:02.982220+08:00 boston kernel: RDX: 0720072007200720
> RSI: 00000000000000d0 RDI: ffff88023bc01900

> 2010-06-06T22:19:16.731591+08:00 boston kernel: RAX: 0720072007200720
> RBX: ffff880237183d28 RCX: ffff88023bc128a0

> 2010-06-07T10:10:35.912264+08:00 boston kernel: RAX: 0720072007200720
> RBX: ffff8802373c9de8 RCX: ffff8802373d14b8

> 2010-06-05T08:50:51.499850+08:00 boston kernel: RDX: 0720072007200720
> RSI: 00007f236f34a000 RDI: ffff88023a9e7100

And my OOPS always seems to happen after X starts up == VT switch from
vt1 to vt7.

Torsten
