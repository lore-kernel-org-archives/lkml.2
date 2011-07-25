Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab1GYL6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:58:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47674 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYL6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:58:18 -0400
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 12:58:17 +0100
X-Google-Sender-Auth: CTzpXpWJd1uuw4wxofmKghke__w
Message-ID: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
Subject: dynamic LCD support for "embedded" systems
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org
Cc: Wookey <wookey@wookware.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[wookey: taking the liberty of cc'ing your message to lkml]
[lkml: this came from an announcement of debian packages for toshiba ac100]

On Mon, Jul 25, 2011 at 11:26 AM, Wookey <wookey@wookware.org> wrote:
> +++ Luke Kenneth Casson Leighton [2011-07-25 10:13 +0100]:
>>  question:
>>
>>  what is the best way to actually take into account, *without*
>> requiring a total recompile of the linux kernel, *without* requiring a
>> rebuild of any debian gnu/linux packages, variations in LCD screen
>> size when the "norm" is that both the LCD and the data structures in
>> the linux kernel are typically static and non-changeable?
>
> That's a question that has bugged me for a long time too.
>
>>  in some ways this is a rhetorical / leading question (but isn't
>> really) - i'm aware that there's usually an I2C ROM or other mechanism
>> for reading EDID data off of the LCD panel, to obtain its size... it's
>> just that this simply isn't done in the linux kernel source code
>> itself.
>
> And sometimes there isn't even that (SFAIK). With a direct LCD connection
> sometimes it's just a matter of what's plugged in. Ballon could have 4
> different displays 3 LCD lanels or a VGA monitor-hack (to get monitor
> signals out of the LCD connector). And I never worked out how to
> switch between displays without making a new kernel, because
> everything was clearly designed on the assumption that if the display
> was LCD then it was of a fixed type.
>
> This is really a question for the kernel list rather than debian-arm.
> I keep hoping some infrastructure for better switching and magic-id
> would appear. Maybe it has for all I know, and I missed it. (I last
> looked at this some time ago).

 ok, so.  does anyone on LKML happen to know if there exists in the
linux kernel a method for dynamic detection and booting off of
absolutely any type of LCD panel?  even if it's a predefined list of
say 10 quotes supported quotes static LCD panels?

 the reason i ask is because although the original request was about
one and only one person ever having publicly reported that they
successfully upgraded their toshiba ac100 tegra2-based laptop to a
decent human-useable 1280x768 LCD panel, i have been working for over
a year to bring about user-hot-swappable CPU "modules" where you would
be able to buy that CPU "module" off-the-shelf in a supermarket and
plug it quite literally into any chassis: 7in tablet, 10in laptop,
desktop PC you don't _give_ a monkey's "it just works".  and under
these circumstances, the present static LCD data structure declaration
system in the linux kernel source code is a recipe for absolute hell
on earth.

 ideas anyone?

 tia,

 l.

 p.s. linus - this is another example of where the complete total
utter lack of hardware standardisation and of the complete
non-existence of a BIOS in the embedded / ARM world (for very good
technical reasons) makes life continued and absolute hell.  ref:
https://lkml.org/lkml/2011/7/1/473
