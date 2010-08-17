Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab0HQQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:20:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38127 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab0HQQUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TqvEszKed2uVm2EP5UrcsLZH1t6wAMQvB6ndY2GU4hbknmFPElCb0XATEd6cjFpOPS
         Nf3s9apKwX98z7PUTgII4bX1tEuq7I7SMdwxgLN27xCkCakJotKsRB9B7O+2r8zJFAre
         wXdOnQrKh6nC1yxTzKFmYznzr0sDptrJjswhY=
MIME-Version: 1.0
In-Reply-To: <20100817153908.GA16155@frolo.macqel>
References: <20100817151142.GA11940@frolo.macqel>
	<AANLkTim3FQ4eOJ2xJR5Kv4PWDbh=tDL0+-NzOaX+dhXo@mail.gmail.com>
	<20100817153908.GA16155@frolo.macqel>
Date: Tue, 17 Aug 2010 18:20:42 +0200
X-Google-Sender-Auth: 6-FYSFmDeMw0Zh6PcCE_UV2KV_I
Message-ID: <AANLkTim4w-ZTxPUmUYEf-YC+kR9BuUdrDibpzKEE6u7p@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] m68knommu : Fix strace support for 68328/68360
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 17:39, Philippe De Muyter <phdm@macqel.be> wrote:
> On Tue, Aug 17, 2010 at 11:14:32AM -0400, Mike Frysinger wrote:
>>
>> unless i'm missing something, you're only changing whitespace here.
>
> That's true,
>
>> and these account for more than half the patch.  please keep
>> whitespace changes separate from real changes.
>
> but that makes comparing the resulting files 68328/entry.S and 68360/entry.S
> easier.

Hence please create two patches:
  - The first one to fix up the whitespace,
  - The second one to fix the bugs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
