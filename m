Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1FEHpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:45:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48310 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1FEHpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pDTrgodViIp+pHFWcNiCeXwipci/zLx6sLEvUZEZ7fxJmgYf25NG0GtqpHRkMLHBDq
         c4t99XYhqbvPjqQ0bJDAwTfx+BsAWXNMT1T2TChNPTHsusmN9Fffny+7QdxnY9W9iLQs
         c6C8yXj9kyn/Q+caRWibUgRhbup1PlTy0cBog=
MIME-Version: 1.0
In-Reply-To: <20110605062702.GA2034@cynthia.pants.nu>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<alpine.OSX.2.00.1106011300550.199@ibook.intranet>
	<20110605062702.GA2034@cynthia.pants.nu>
Date: Sun, 5 Jun 2011 09:45:14 +0200
X-Google-Sender-Auth: Q0JI3jftJ9AOA3i2bTKhI8al8Pw
Message-ID: <BANLkTim+Rkz4i1Z8iGD8nDHtTJ1b82uAYQ@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Brad Boyer <flar@allandria.com>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 08:27, Brad Boyer <flar@allandria.com> wrote:
> On Fri, Jun 03, 2011 at 09:20:23PM +1000, Finn Thain wrote:
>> On Sat, 28 May 2011, Geert Uytterhoeven wrote:
>> > Of course any help is welcome, especially for Mac
>>
>> What kind of help are you looking for? I read through your patch series
>> but I'm not sure how much work is left. Probably I need to look at a
>> genirq reference implementation to get an idea of the goal...
>
> If there are any good documents on genirq, I would like to look at it
> as well. I didn't see anything obvious in Documentation/ in the tree.

Documentation/DocBook/genericirq.tmpl

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
