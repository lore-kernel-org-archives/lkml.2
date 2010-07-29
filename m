Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0G2IFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:05:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0G2IFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:05:49 -0400
Message-ID: <4C51362E.5010009@suse.cz>
Date: Thu, 29 Jul 2010 10:05:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: trapdoor6@gmail.com
Cc: Nir Tzachar <nir.tzachar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Subject: Re: Small typo in kernel [current source from git] .config option
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>	<20100727165549.GC26649@merkur.ravnborg.org>	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>	<4C500E41.40708@suse.cz>	<AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>	<4C504FBB.3020600@suse.cz>	<20100728185505.GF29266@merkur.ravnborg.org>	<AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com> <AANLkTimhKT=mmL7Q5D1z2mzu7wt25_NzA328Tp3T8y0v@mail.gmail.com>
In-Reply-To: <AANLkTimhKT=mmL7Q5D1z2mzu7wt25_NzA328Tp3T8y0v@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.7.2010 08:20, trapDoor wrote:
> On Thu, Jul 29, 2010 at 6:04 AM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
>> On Wed, Jul 28, 2010 at 9:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>> The capitilazing is the main reason why I have
>>> not recommended nconfig to be default.
>>>
>>> And I doubt the shortcut letters are used that often.
>>> One idea could be to drop the shortcut for the individual menus.
>>
>> I almost never use them and removing them will have the benefit of
>> cleaning the code.
> 
> Neither do I. And I don't know anyone who would find them very useful.

I actually do. Unlike menuconfig, nconfig will jump to a menu item even
if it is not currently visible in the screen. Useful if you know the
option name but don't want to scroll down and look for it. But I would
accept a patch to remove the shortcut if there is no better way of
marking the shortcuts than the capital letters.

Michal
