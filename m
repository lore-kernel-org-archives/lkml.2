Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0G1MRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:17:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0G1MRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=W+Revr9cWCtoXrvDrf2dfA3PCQHvuD6BqVVFGxZNIfZBWVDQIJS7OJEuZ6j2bn4WkO
         pvG3c6YahK6l2irBEZaK064+GwmZ02YdUl+ggCv4GduNTdzzWcthtXZQft9K3TBMDX+c
         6kQqh5ISQ52hJUF0YAZyA81PB2JsJ0yhf9sZo=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <4C500E41.40708@suse.cz>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
	<4C500E41.40708@suse.cz>
Date: Wed, 28 Jul 2010 13:17:38 +0100
Message-ID: <AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: trapDoor <trapdoor6@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:02 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 27.7.2010 19:12, trapDoor wrote:
>> On Tue, Jul 27, 2010 at 5:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>> On Tue, Jul 27, 2010 at 03:46:45PM +0100, trapDoor wrote:
>>>> Hello,
>>>> I've just got lucky and found this little typo under "Power management
>>>> and ACPI options"  ---> "ACPI (Advanced Configuration and Power
>>>> Interface) Support":
>>>> hArdware Error Device
>>>>
>>>> Here is my fix:
>>>> Hardware Error Device
>>>> :)
>>>>
>>>> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>>>
>>> The capital "A" is nconfigs way to tell you that you can use
>>> "a" as shortcut to reach the menu.
>>
>> Rignt! So it's just a 'mnemonic' and only appears like that in nconfig
>> (I see that now). I'd guess that if I've ever made any use of
>> mnemonics here.
>
> For completeness - This affects any option that starts with H, Y, M or
> N, as these letters are taken (they stand for Help, Yes, Module and No,
> respectively). Unfortunatelly, there doesn't seem to be a way to
> highlight single letters in an ncurses menu, hence the strange
> cApitalization :(.
>
> Michal
>

I wonder how is this resolved in other console applications such as
Midnight Commander. Does it have its own implementation for
highlighting characters (it uses coloured mnemonics e.g. in menus) or
it's based on some common Linux/Unix library which perhaps could be
used for the nconfig as well? Unless MC depends on any part of X env.
but I don't think it does. On the project's official website it says:

"Midnight Commander is based on versatile text interfaces, such as
Ncurses or S-Lang, which allows it to work on a regular console,
inside an X Window terminal, over SSH connections and all kinds of
remote shells."

So either ncurses or s-lang, no mention about other dependences in
their documentation. Also by looking at some forums, when people have
problems with installing MC it's usually due to missing s-lang

-- 
Regards
trapDoor
