Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab1IOOlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:41:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33888 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab1IOOlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <web-606831561@zbackend1.aha.ru>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Sep 2011 07:41:30 -0700
X-Google-Sender-Auth: 4GYg7k7BmGRDc1x7QcQ2fhdQAvQ
Message-ID: <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: werner <w.landgraf@ru.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 werner <w.landgraf@ru.ru>:
> The config is below. šThat's the M486 config which don't boor. šThe M586
> config which boots has the diff given in my last mail, and which for make
> the comparison more easy I give below again. š As said, all 3.0-rcX and up
> to 3.0.4 boot with 486 too, the problem started with 3.1-rc1 . Perhaps the
> šmessages before the computer sticked (using the M486 config below) which I
> copied manually from the screen, posted in the treat 3.1-rc5 boot problem š,
> may be helpful to find out what exactly causes the sticking.
> wl

Gack.  I obviously did a terrible job grepping for this stuff when I
wrote the original patch.  The problem is probably in static_cpu_has.
I'll send a patch in a little bit.

--Andy
