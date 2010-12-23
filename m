Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0LWGDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:03:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34791 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LWGDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AW6ZYzz6KFGja+axeVZprG0mGTEcnemyMT14EI3dC67O8zOrzvpqZM7wHjr/S92Wdu
         X7wo+mtq5Ri5vCINgoMApkR0zMxk5HdYWqWuyS5aiHorEDcJLIyPFBcTc205Ys9xuqME
         aJVmunYMtmTaSaOAA3KQsEXHYBeb/rCIiLEEk=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
	<s5hei99vkqj.wl%tiwai@suse.de>
	<c6d829$pujifv@fmsmga001.fm.intel.com>
	<AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
Date: Thu, 23 Dec 2010 16:03:17 +1000
Message-ID: <AANLkTimUUNW2cAc9fcqemyAuSPtZPJUfEiPPrRxOwdwN@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 1:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 22, 2010 at 8:59 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Wed, 22 Dec 2010 17:24:36 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>>> The commit 448f53a1ede54eb854d036abf54573281412d650
>>>   drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
>>>
>>> causes a regression on a SandyBridge machine here.
>>> The laptop display (LVDS) becomes blank.  Reverting the commit fixes
>>> the problem.
>>
>> The question is whose BIOS is wrong?
>
> I don't think so.
>
>>                         The Lenovo U160's or the
>> Sandybridge SDV? And why does it work for that other OS? <Insert
>> rhetorical question of the day here.>
>
> Quite frankly, I don't think the question should *ever* be "whose BIOS
> is wrong?"
>
> You should always take for granted that the BIOS is wrong. It's not a
> question of "blame the BIOS", it's a question of facts of life.
>
> It's 100% pointless to point fingers and say "the HP BIOS is wrong" or
> "the Lenovo BIOS is wrong". Buggy BIOSes happen. ALWAYS. Any code that
> relies on the BIOS to such a degree that it either works or not based
> on it is by definition broken.
>
> Why does that code need to figure out some LVDS clock from the BIOS?
> Why can't the code look at the actual hardware state or similar, since
> presumably the screen is on after boot. THAT we can rely on, since a
> BIOS that doesn't initialize LVDS is not going to ever ship even as
> pre-release.
>

I've no idea but since this is spread-spectrum related the bios may not enable
spread-spectrum on the panel, though really the question is as always, what does
Windows do.

Dave.
>                        Linus
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
