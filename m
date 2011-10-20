Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1JTQDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:03:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52087 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1JTQD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVMp65XzV2zu7V8sgwsniCAxD7NDDnHSvp5gO-8g1ovHg@mail.gmail.com>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com>
	<alpine.LNX.2.00.1110202347320.2696@nippy.intranet>
	<CAMuHMdVMp65XzV2zu7V8sgwsniCAxD7NDDnHSvp5gO-8g1ovHg@mail.gmail.com>
Date: Thu, 20 Oct 2011 18:03:28 +0200
X-Google-Sender-Auth: jgyqPihEJvE3RZQopMUu_BonLAE
Message-ID: <CAMuHMdW7x1_6P6UiaiHf-ynvsGjX76eZtw4PU2SvberKGD69hg@mail.gmail.com>
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 17:02, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Oct 20, 2011 at 15:40, Finn Thain <fthain@telegraphics.com.au> wrote:
>> Sounds good. The mac_esp fix I sent is already in linux-next.
>
> Thanks for reminding me I still have to apply that one :-)

That's e544d704f9bea6892808e453e219aa305bc0269a
("[SCSI] mac_esp: remove redundant mutual exclusion")?
And it should be applied (at least to m68k/master)_before_ the genirq
conversion, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
