Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2E1Jdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:33:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60689 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2E1Jds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:33:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120528071421.GB3014@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
	<20120423154342.GB23990@kroah.com>
	<CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
	<20120424143624.GB3438@kroah.com>
	<CACRpkdZ0MnMLxvi4oFv-s8aut_zRfQh_OQN6HoXHkXmrtkSmzA@mail.gmail.com>
	<20120528071421.GB3014@kroah.com>
Date: Mon, 28 May 2012 17:33:47 +0800
Message-ID: <CACRpkdaoeSRiS28Epmp7UVGercOuySM2VC6Jiqoi4THU-WE7aQ@mail.gmail.com>
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

On Mon, May 28, 2012 at 3:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, May 28, 2012 at 02:38:09PM +0800, Linus Walleij wrote:
>> On Tue, Apr 24, 2012 at 10:36 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:

>> > That didn't answer my question at all.  Oh well, 3.5 it is...
>>
>> Is this going upstream in this merge window? I haven't seen it
>> in Torvalds' tree, but I guess it may be pending for a late
>> merge...?
>
> Nope, it missed 3.5 as no one ever answered my questions, so I guessed
> that no one really cares about this :(

I care. Anyway, Rafael has ACK:ed it so please merge it as any
other patch for kernel 3.6.

If somebody wants to for CC @stable, speak up.

Yours,
Linus Walleij
