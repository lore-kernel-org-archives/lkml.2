Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1HWDuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:50:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55207 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1HWDuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110822.191348.2099822249437201579.davem@davemloft.net>
References: <20110822113032.15087c2e190e2b0c3ee7dfb8@canb.auug.org.au>
	<20110823114011.a059aea0138b75bfa7eed1ce@canb.auug.org.au>
	<20110823114129.ceb18da164bf7df3c145941b@canb.auug.org.au>
	<20110822.191348.2099822249437201579.davem@davemloft.net>
Date: Mon, 22 Aug 2011 23:50:02 -0400
Message-ID: <CACqU3MW4BnucRt3gxPrKPDvWEjaVuxRF1VOPWk5hTRfneyANkg@mail.gmail.com>
Subject: Re: linux-next: boot test failure (net tree)
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        mikey@neuling.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Added linux-kbuild@ to the Cc: list.]

On Mon, Aug 22, 2011 at 10:13 PM, David Miller <davem@davemloft.net> wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 23 Aug 2011 11:41:29 +1000
>
>> On Tue, 23 Aug 2011 11:40:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> On Mon, 22 Aug 2011 11:30:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> >
>>> > Here's what I am applying as a merge fixup to the net tree today so that
>>> > my ppc64_defconfig builds actually build more or less the same set of
>>> > drivers as before this rearrangement.
>>>
>>> And this today:
>>
>> And this:
>
> I'm starting to get uncomfortable with this whole situation, and I
> feel more and more that these new kconfig guards are not tenable.
>
> Changing defconfig files might fix the "automated test boot with
> defconfig" case but it won't fix the case of someone trying to
> automate a build and boot using a different, existing, config file.
> It ought to work too, and I do know people really do this.
>
> And just the fact that we would have to merge all of these defconfig changes
> through the networking tree is evidence of how it's really not reasonable
> to be doing things this way.
>
> Jeff, I think we need to revert the dependencies back to what they were
> before the drivers/net moves.  Could you prepare a patch which does that?
>
Are you implying we need some kind of way to migrate config ?

 - Arnaud
