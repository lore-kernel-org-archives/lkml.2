Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0G2GUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 02:20:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55386 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0G2GUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 02:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=ElUenwinKLJcBW+z0lZztEzhXiAiGgmuc8BeqBe5NLO5mXeCj5V0Qt8GlcvFmUOG9C
         brrEPI8pLl7u0pEpFJq52eO9JH45Q1NVEvg1kQnSV/Zr29G/KQGnO/N36fzhkz809hQQ
         alG4bj03dK4NCWh2SOxJ80Gf9WLNzh5VkGJFc=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
	<4C500E41.40708@suse.cz>
	<AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
	<4C504FBB.3020600@suse.cz>
	<20100728185505.GF29266@merkur.ravnborg.org>
	<AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com>
Date: Thu, 29 Jul 2010 07:20:19 +0100
Message-ID: <AANLkTimhKT=mmL7Q5D1z2mzu7wt25_NzA328Tp3T8y0v@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: trapDoor <trapdoor6@gmail.com>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 29, 2010 at 6:04 AM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
> Hello.
>
> On Wed, Jul 28, 2010 at 9:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> On Wed, Jul 28, 2010 at 05:41:47PM +0200, Michal Marek wrote:
>>> (adding Nir, who wrote nconfig, to CC).
>>>
>>> On 28.7.2010 14:17, trapDoor wrote:
>>> > On Wed, Jul 28, 2010 at 12:02 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> >> respectively). Unfortunatelly, there doesn't seem to be a way to
>>> >> highlight single letters in an ncurses menu, hence the strange
>>> >> cApitalization :(.
>>> >
>>> > I wonder how is this resolved in other console applications such as
>>> > Midnight Commander. Does it have its own implementation for
>>> > highlighting characters (it uses coloured mnemonics e.g. in menus) or
>>> > it's based on some common Linux/Unix library which perhaps could be
>>> > used for the nconfig as well?
>>>
>>> The problem is that nconfig uses the higher-level ncurses libraries
>>> libmenu and libpanel, which make some things easier, but aren't as
>>> flexible as using ncurses directly. Patches are welcome of course :-).
>
> The problem does arise from the use of libmenue, which gives you no
> control over the rendering of menue items. You can not specify any
> attributes for specific menu item's letters.
>
>> The capitilazing is the main reason why I have
>> not recommended nconfig to be default.
>>
>> And I doubt the shortcut letters are used that often.
>> One idea could be to drop the shortcut for the individual menus.
>
> I almost never use them and removing them will have the benefit of
> cleaning the code.
>

Neither do I. And I don't know anyone who would find them very useful.
Anyway, if you compile kernel regularly, especially from git, you
usually keep the same .config from previous compilations, and just run
make oldconfig rather than any of the graphical tools. Unless you want
to do some major changes. But even then I don't think many people
would care about key shortcuts.

Only if they were going to be kept in nconfig I'd say that fixing the
capitalisation somehow would be a good thing to do. But if you are
going to remove them and thus make the fix possible and the code
cleaner - that suits me. I will still prefer the simple and clean
nconfig's interface over menuconfig with mnemonics.

> A different approach may be to reimplement libmenu's logic (recreating
> the old lxdialog code), but avoiding this was part of the reason for
> writing nconfig....
>
> In any way, I am happy people are starting to use nconfig.
> Cheers.
>

-- 
Thanks,
trapDoor
