Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0G2Kdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:33:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47459 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab0G2Kdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k+gwz0QI5RfPWUTL1Q96KMTK+WvMyDNGSejiLlDmbhr3IAi4bePsC1pHfmgZWM0c6t
         Bb2eYo73S4d0j8NFMB6Anb4bUlVhLDQ8MTvRkUsPk4oVODGSvJPkMISQAWypw1BXuvPq
         qqD+hhiCfgj0mp2T5qkvyJ2AieOLTn3r2+Y2o=
MIME-Version: 1.0
In-Reply-To: <4C51362E.5010009@suse.cz>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
	<4C500E41.40708@suse.cz>
	<AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
	<4C504FBB.3020600@suse.cz>
	<20100728185505.GF29266@merkur.ravnborg.org>
	<AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com>
	<AANLkTimhKT=mmL7Q5D1z2mzu7wt25_NzA328Tp3T8y0v@mail.gmail.com>
	<4C51362E.5010009@suse.cz>
Date: Thu, 29 Jul 2010 13:33:49 +0300
Message-ID: <AANLkTi=7ioo3HPVhWYu5OmyoOcaedzyQQ9z=5w2MrTt4@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: trapdoor6@gmail.com, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 11:05 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 29.7.2010 08:20, trapDoor wrote:
>> On Thu, Jul 29, 2010 at 6:04 AM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
>>> On Wed, Jul 28, 2010 at 9:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>> The capitilazing is the main reason why I have
>>>> not recommended nconfig to be default.
>>>>
>>>> And I doubt the shortcut letters are used that often.
>>>> One idea could be to drop the shortcut for the individual menus.
>>>
>>> I almost never use them and removing them will have the benefit of
>>> cleaning the code.
>>
>> Neither do I. And I don't know anyone who would find them very useful.
>
> I actually do. Unlike menuconfig, nconfig will jump to a menu item even
> if it is not currently visible in the screen. Useful if you know the
> option name but don't want to scroll down and look for it. But I would
> accept a patch to remove the shortcut if there is no better way of
> marking the shortcuts than the capital letters.
>
> Michal
>

There is a middle ground here: keep the shortcuts, but give no visual
indication (either capitalization or coloring).

What do you say? I actually like this, as I dislike the ugly
capitalization hack.

Cheers.
