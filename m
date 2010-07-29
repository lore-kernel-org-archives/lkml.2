Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0G2FEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:04:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0G2FEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fhyMacefEUWG+UIcuirIN3MNjtuZAc236t7/9oASlYa75N+E0Can5r/TDg6vMMggEd
         S1/dLng+mAMAs9e6hXi8bK9nkXj7q8zEeA9bqYXZtusqoP+X9dzdXqfIlUdLPT86K3YN
         u0tamFyCNz90NI+mOPSD3pBXKlo/jK41megzE=
MIME-Version: 1.0
In-Reply-To: <20100728185505.GF29266@merkur.ravnborg.org>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
	<4C500E41.40708@suse.cz>
	<AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
	<4C504FBB.3020600@suse.cz>
	<20100728185505.GF29266@merkur.ravnborg.org>
Date: Thu, 29 Jul 2010 08:04:51 +0300
Message-ID: <AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, trapdoor6@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Wed, Jul 28, 2010 at 9:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jul 28, 2010 at 05:41:47PM +0200, Michal Marek wrote:
>> (adding Nir, who wrote nconfig, to CC).
>>
>> On 28.7.2010 14:17, trapDoor wrote:
>> > On Wed, Jul 28, 2010 at 12:02 PM, Michal Marek <mmarek@suse.cz> wrote:
>> >> respectively). Unfortunatelly, there doesn't seem to be a way to
>> >> highlight single letters in an ncurses menu, hence the strange
>> >> cApitalization :(.
>> >
>> > I wonder how is this resolved in other console applications such as
>> > Midnight Commander. Does it have its own implementation for
>> > highlighting characters (it uses coloured mnemonics e.g. in menus) or
>> > it's based on some common Linux/Unix library which perhaps could be
>> > used for the nconfig as well?
>>
>> The problem is that nconfig uses the higher-level ncurses libraries
>> libmenu and libpanel, which make some things easier, but aren't as
>> flexible as using ncurses directly. Patches are welcome of course :-).

The problem does arise from the use of libmenue, which gives you no
control over the rendering of menue items. You can not specify any
attributes for specific menu item's letters.

> The capitilazing is the main reason why I have
> not recommended nconfig to be default.
>
> And I doubt the shortcut letters are used that often.
> One idea could be to drop the shortcut for the individual menus.

I almost never use them and removing them will have the benefit of
cleaning the code.

A different approach may be to reimplement libmenu's logic (recreating
the old lxdialog code), but avoiding this was part of the reason for
writing nconfig....

In any way, I am happy people are starting to use nconfig.
Cheers.
