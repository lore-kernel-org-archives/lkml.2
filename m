Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1H2MPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:15:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46593 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1H2MPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4xXMx7_G2ADJF-s4Xws4k4XqBnE3eysokd66ogdb=jbOA@mail.gmail.com>
References: <1314329782-17238-1-git-send-email-Baohua.Song@csr.com>
	<CACRpkdYmmY8ycBUL70ERawumSMdZEORYsmMBxBxZxchcfMS7EA@mail.gmail.com>
	<CAGsJ_4xXMx7_G2ADJF-s4Xws4k4XqBnE3eysokd66ogdb=jbOA@mail.gmail.com>
Date: Mon, 29 Aug 2011 14:15:38 +0200
Message-ID: <CACRpkdb=V2MSyQy+9KXYCRE2O0sttF9XNTp4Jiug4Z-Cqs6nWQ@mail.gmail.com>
Subject: Re: [PATCH] pinmux: add a driver for the CSR SiRFprimaII pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Baohua.Song@csr.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        grant.likely@secretlab.ca, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:58 PM, Barry Song <21cnbao@gmail.com> wrote:
>> > +static const struct sirfsoc_muxmask lcd_16bits_sirfsoc_muxmask[] = {
>> > +       {
>> > +               .group = 3,
>> > +               .mask = 0x7FFFF,
>>
>> These things look a bit magic...
>
> register seems to be magic by itself. this is register set mask of
> group 3 for LCD. group in the structure is also an offset of register
> layout.

No big deal anyway.

What some people like myself do is make #defines for most
things:

#define SIRFSOC_LCD_GROUP_OFFSET 3
#define SIRFSOC_LCD_GROUP_MASK 0x7FFFF
#define SIRFSOC_LCD_ENABLE BIT(5)

sometimes I even define shifts for masks etc.

But a comment inline explaining the magic bits is just as
fine with me.

Yours,
Linus Walleij
