Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0D0MvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:51:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44861 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0D0MvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YZ2P3KcDUJCd+p+cZcsrz2QRG2bOKochnPhwZs0ndvc1UnQAnTa9XLjJ3kNNATAKaq
         XTnJcuZmr8+rGntH0vmwzwE3qU+ivcWYdV0Pe0AnhpAK6P6slw0H1UA80dHGzAYz8WX7
         avIoatzKAF3Dd2GmNE0f5eWoHwuJ4LmowS9ms=
MIME-Version: 1.0
In-Reply-To: <201004271331.58130.arnd@arndb.de>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
	 <201004271331.58130.arnd@arndb.de>
Date: Tue, 27 Apr 2010 14:51:16 +0200
X-Google-Sender-Auth: 1bfbd26deb79d7da
Message-ID: <q2q10f740e81004270551jfcefb86aqbdb861e7a6cc7f4b@mail.gmail.com>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 13:31, Arnd Bergmann <arnd@arndb.de> wrote:
> a) arch specific drivers
>  arch/m68k/bvme6000/rtc.c                    |    2 +-
>  arch/m68k/mvme16x/rtc.c                     |    2 +-

Don't waste your time on these:
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=commit;h=ce266e954a1bc7cef51115faacaf3d390b534755

Gr{oetje,eeting}s,

						Geert (still has to update his for-next branch for 2.6.35).

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
