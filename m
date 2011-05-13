Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1EMFRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:17:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49685 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1EMFRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iWIAJI7nneZntCGPkW/E3HVYzUcRATKa5AcXFlUhK6c9fhPQJAdwIy1tksQ+jf2TM3
         wfO0k8pz/Z1WjfmYF+BboXB09f/pMYWGqgn+fnMNWm1FFbhudhT68NGBvJxy5fyMq5z/
         5yxC7BHGCvqOI6HcNEjx8CeDCXVyFLJE+Byf8=
MIME-Version: 1.0
In-Reply-To: <20110512.170254.1553444447781324461.davem@davemloft.net>
References: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
	<20110512.170254.1553444447781324461.davem@davemloft.net>
Date: Fri, 13 May 2011 07:17:04 +0200
X-Google-Sender-Auth: eYgfTugOQRG8_dLArPUhZT2PvK8
Message-ID: <BANLkTi=y6_0NtZSyMovjV7wfbH5i_caEhw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix 8390 regressions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, ysato@users.sourceforge.jp, linux@arm.linux.org.uk,
        fthain@telegraphics.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 23:02, David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Thu, 12 May 2011 19:11:37 +0000
>
>> These patches fix regressions in 3 8390-based network drivers:
>>  [1/3] zorro8390: Fix regression caused during net_device_ops conversion
>>  [2/3] hydra: Fix regression caused during net_device_ops conversion
>>  [3/3] ne-h8300: Fix regression caused during net_device_ops conversion
>>
>> The first one, for zorro8390, has been tested.
>> The second one, for hydra, has been compile-tested only.
>>
>> Based on commits 8cfd9e923be54ef66ce174a93f4592b444b96407 ("[ARM] RiscPC: Fix
>> etherh oops") and 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390: fix
>> regression caused during net_device_ops conversion"), and the patch for
>> zorro8390, we have good reasons to believe hydra and ne-h8300 are affected
>> as well, as they all include lib8390.c.
>> Hence patches for those are also included, although I could not test them.
>
> All applied, thanks Geert, and I made the "From: " removals you requested.

Thanks a lot!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
