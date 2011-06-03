Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1FCLdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:33:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1FCLdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hx43k0oL2BmmMBE2s5ATrzLzi64VOpi7348yV3LK1Q6pC6KEupB+hU4JwDrfSQt1Ti
         xEr3Q5fnonzI7Z8A1s1ONfxdcAZ/ua56lmNyuy2kL5QLYBLnLGG7YKJwzcgIR5zjxL/A
         u+E4C9PAPzNNvWYoOLLOiEsFojCC4qSl1ZPM4=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<alpine.OSX.2.00.1106011300550.199@ibook.intranet>
Date: Fri, 3 Jun 2011 13:33:36 +0200
X-Google-Sender-Auth: -d1nfn8WFnWc2LZQo2k8q_FtqhQ
Message-ID: <BANLkTi=uSwNbYzjDF7hHp+aygPc0gvHoFg@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 13:20, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sat, 28 May 2011, Geert Uytterhoeven wrote:
>> Of course any help is welcome, especially for Mac
>
> What kind of help are you looking for? I read through your patch series
> but I'm not sure how much work is left. Probably I need to look at a
> genirq reference implementation to get an idea of the goal...

I could use help in the form of converting the various m68k subplatforms over to
genirq.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
