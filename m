Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2HJIso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:48:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51167 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2HJIsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120809194044.GA9966@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<20120809185029.GC24328@opensource.wolfsonmicro.com>
	<20120809194044.GA9966@gmail.com>
Date: Fri, 10 Aug 2012 10:48:39 +0200
Message-ID: <CACRpkdZCKQCkWSPYby2rYd4Oas481nZE7eDmZRETovJOks2p0Q@mail.gmail.com>
Subject: Re: [PATCH 00/22] mop500 related Audio reorganisation and fixups
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 9:40 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, Aug 09, 2012 at 07:50:29PM +0100, Mark Brown wrote:
>> On Thu, Aug 09, 2012 at 04:47:26PM +0100, Lee Jones wrote:
>> > Another fine instalment of Audio fixes and Device Tree enablement
>> > surrounding the mop500 sound driver. Hopefully containing all of
>> > the recommendations suggested by Mark Brown.
>>
>> Can we have some review of this from the ARM side please?  It's pretty
>> big...
>
> I don't expect Linus will do anything until he returns back from vacation.

I'm back from vacation, and catching up. Now there is a few different
DT patch bombs from you in my inbox, which patchset shall I review
first? This one? Or is there a more urgent one?

Yours,
Linus Walleij
