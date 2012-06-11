Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2FKQa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:30:59 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42080 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2FKQa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaoeSRiS28Epmp7UVGercOuySM2VC6Jiqoi4THU-WE7aQ@mail.gmail.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
	<20120423154342.GB23990@kroah.com>
	<CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
	<20120424143624.GB3438@kroah.com>
	<CACRpkdZ0MnMLxvi4oFv-s8aut_zRfQh_OQN6HoXHkXmrtkSmzA@mail.gmail.com>
	<20120528071421.GB3014@kroah.com>
	<CACRpkdaoeSRiS28Epmp7UVGercOuySM2VC6Jiqoi4THU-WE7aQ@mail.gmail.com>
Date: Mon, 11 Jun 2012 18:30:56 +0200
Message-ID: <CACRpkdajR8one1NjXh14UFymVtmP_UUgNavz-oRcZLV-ZavBBA@mail.gmail.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 11:33 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Mon, May 28, 2012 at 3:14 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Mon, May 28, 2012 at 02:38:09PM +0800, Linus Walleij wrote:
>>> On Tue, Apr 24, 2012 at 10:36 PM, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>
>>> > That didn't answer my question at all.  Oh well, 3.5 it is...
>>>
>>> Is this going upstream in this merge window? I haven't seen it
>>> in Torvalds' tree, but I guess it may be pending for a late
>>> merge...?
>>
>> Nope, it missed 3.5 as no one ever answered my questions, so I guessed
>> that no one really cares about this :(
>
> I care. Anyway, Rafael has ACK:ed it so please merge it as any
> other patch for kernel 3.6.

Just a friendly poke to queue this for testing in -next for the v3.6
merge window...

Yours,
Linus Walleij
