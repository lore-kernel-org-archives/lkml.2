Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1H2INw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:13:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37631 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1H2INq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110829095530.789ec9ea@endymion.delvare>
References: <1312802446-19154-1-git-send-email-geert@linux-m68k.org>
	<20110816195033.014f302b@endymion.delvare>
	<CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
	<20110817113910.47dc819f@endymion.delvare>
	<CAMuHMdVX_p4Q1E+-Q1HOjUO-Zhbsv_uji2qqGZipii=qY0hHWw@mail.gmail.com>
	<20110829095530.789ec9ea@endymion.delvare>
Date: Mon, 29 Aug 2011 10:13:44 +0200
X-Google-Sender-Auth: iOTSCRSUz_AKIXHqJyLhTR7U_tQ
Message-ID: <CAMuHMdVi7GK06NMqZwpN+AuJEC+F51LhVMED0hOFVwb7hxxYFg@mail.gmail.com>
Subject: Re: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Berglund <hb@spacetec.no>, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Aug 29, 2011 at 09:55, Jean Delvare <khali@linux-fr.org> wrote:
> On Mon, 29 Aug 2011 09:48:17 +0200, Geert Uytterhoeven wrote:
>> On Wed, Aug 17, 2011 at 11:39, Jean Delvare <khali@linux-fr.org> wrote:
>> > OK, fair enough. Patch applied, thanks.
>>
>> Any chance it will finds its way in 3.1, since it's still breaking
>> m68k allmodconfig builds.
>
> This is the plan, yes. It should happen by the end of the week.

Great, thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
