Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1FONLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:11:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41284 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1FONLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p04mT6HyAK5P1n8NYapqTDaXG0yt0sPWqN3m4iTAoI539l6E93QjPZcahkuB6c1+EW
         Cx6COZiuf07EEM4HTthCTn0HU/X/44eQ/wys5zENlUxv5DLCTLTOgi1/LBnJtWN8c6Tq
         3LrPMYCxuiXqj8pa9bFhMLZUwq9d2Bao4Aw+c=
MIME-Version: 1.0
In-Reply-To: <20110615224139.96a28669.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<20110615224139.96a28669.sfr@canb.auug.org.au>
Date: Wed, 15 Jun 2011 15:11:46 +0200
X-Google-Sender-Auth: trY19bRTRukWHokvMUEuYBnlS_I
Message-ID: <BANLkTinfo4PRLX0NKj7zrgj_O1xXvP+j5Q@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 14:41, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 15 Jun 2011 11:11:54 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> [1] http://kisskb.ellerman.id.au/kisskb/head/4110/ (107 out of 108 configs)
>> [2] http://kisskb.ellerman.id.au/kisskb/head/4019/ (all 108 configs)
>> [3] http://kisskb.ellerman.id.au/kisskb/head/4085/ (107 out of 108 configs)
>
> Hmm, the web page says that there are 107 configs.  The extra one is
> systemh_defconfig on sh4.  Not sure what is up there.

That one got dropped from the build bot recently on request from Paul
Mundt, IIRC.
After 3.0 is released and I will no longer compare with 2.6.39, I'll
drop it, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
