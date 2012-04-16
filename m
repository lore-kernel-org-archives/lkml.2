Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2DPVkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:40:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59070 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2DPVj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:39:58 -0400
Message-ID: <4F8C9191.8000800@gmail.com>
Date: Mon, 16 Apr 2012 14:39:29 -0700
From: Don deJuan <donjuansjiz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
References: <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413190819.9469.qmail@stuge.se> <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com> <20120416162710.GA24100@kroah.com> <CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com> <20120416205856.GA22298@kroah.com> <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com>
In-Reply-To: <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 02:18 PM, Felipe Contreras wrote:
> On Mon, Apr 16, 2012 at 11:58 PM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>> On Mon, Apr 16, 2012 at 11:11:05PM +0300, Felipe Contreras wrote:
>>> On Mon, Apr 16, 2012 at 7:27 PM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>>>> Just one minor correction in this looney email thread:
>>>>
>>>> On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
>>>>> v3.3.x on the other hand are *not* stable. They contain patches
>>>>> backported from v3.4, but nobody guarantees they will work. There was
>>>>> no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
>>>>> generally tested together is in v3.3.1, at which point if somebody
>>>>> finds issues, it's too late; bad patches are *not* going to be removed
>>>>> in v3.3.2.
>>>>
>>>> Of course there was a 3.3.1-rc1, see the linux-kernel archives for the
>>>> announcemen and the individual patches.  kernel.org has the large patch
>>>> itself if you like that format instead.
>>>
>>> I don't see it here:
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=tags
>>>
>>> If you really want people to try it, why not tag it?
>>
>> That would be because I don't keep it in that tree.  It is in a quilt
>> tree you can find in the stable-queue.git repo, and I have never tagged
>> -rc1 releases there.  No one has ever asked for it before, so in the
>> past 6 years of stable releases, I guess no one ever needed it.
>>
>> ketchup and tarballs seem to work well for others, perhaps you can use
>> that as well (hint, ketchup on top of the linux-stable tree works just
>> fine for testing this.)
>
> Perhaps the current process will be continue to be OK, but I do
> believe a tagged v3.3.1-rc1 would have catched the ath9k issue.
> Hopefully that would mean it could have been dropped/reverted for
> v3.3.1.
>
> I used to compile my own kernels and use your stable tree, but this a
> new laptop and I was using Arch Linux which automatically updated to
> v3.3.1, and with no network I had no way to revert to v3.2.x.

For an Arch user I am shocked you are able to keep things going on your 
setup. Why are you not spending this much effort complaining to Arch 
Dev's for not properly testing 3.3.1 before pushing it. I know they did 
not put it into testing and was just put through the mailing list for 
people to test, with only a few ack's showing up on the list, before 
pushing about a day later.

Also how did you not have something to roll back to? Why was there not a 
package left in your /var/cache/pacman/pkg cache? Unless you clean out 
your cache way to often you should have more than one kernel you could 
have "rolled back" with a simple pacman -U linux-version-that-last-worked.

This much effort and bitching on your part to people who had nothing to 
do with you getting a bad push from Arch, Arch should have done further 
testing of it OR you should have waited a day before updating to see if 
anything on your shiny new laptop would have been effected.

> Fortunately I had the kernel sources available, but I wonder how many
> people were completely stuck.

On arch no one should have been stuck if they would have read the wiki's 
and been more aware of their systems. Stable or not you are living on 
the bleeding edge or as close to it as possible when on Arch, read their 
philosophy and methods and their wiki. Then if you have issues with 
something Arch pushes to you, would it not be better to spend your 
efforts on the distro you are running?

>
> If some other 3.x.1 release get broken this way, I would seriously
> consider tagging v3.x.1-rc1 as well. It works for Linus' tree.
>
> Cheers.
>


Just my .02 from someone not involved in any of this who is just fed up 
with you twisting crap around to fit your gripes with something that is 
not related to the trees or methods at hand. YOU got a package from YOUR 
distro of choice and because YOU were not aware of things when updating 
your distro YOU broke it. Not Linus or Greg, but Arch and you not 
understanding the kernel did NOT go through the normal testing repo. I 
have a system that would have broke in the same manner as yours, running 
Arch, but because I am aware I have a few things that are getting lots 
of work in the kernel, I need to be aware of the updates, especially 
kernel's just being tested through the mailing list. Also why did you 
not have at least the LTS as a backup on your Arch install, if you are 
clearing out your cache so frequently to not have at least one version 
to "roll back"?
Learn your hardware and how it interacts with the distro you choose and 
you can better help yourself and ALL these efforts would not just end up 
making you seem like a ranting loon!

