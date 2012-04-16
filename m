Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2DPWDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:03:21 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57381 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2DPWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:03:19 -0400
Message-ID: <4F8C970B.5070801@gmail.com>
Date: Mon, 16 Apr 2012 15:02:51 -0700
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
References: <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413190819.9469.qmail@stuge.se> <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com> <20120416162710.GA24100@kroah.com> <CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com> <20120416205856.GA22298@kroah.com> <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com> <20120416212718.GA22824@kroah.com> <CAMP44s3fMyBM_N0kP7xZbY-assePMrnWouPy-kw-WyHnKmeLWA@mail.gmail.com>
In-Reply-To: <CAMP44s3fMyBM_N0kP7xZbY-assePMrnWouPy-kw-WyHnKmeLWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 02:50 PM, Felipe Contreras wrote:
> On Tue, Apr 17, 2012 at 12:27 AM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>> On Tue, Apr 17, 2012 at 12:18:13AM +0300, Felipe Contreras wrote:
>>> On Mon, Apr 16, 2012 at 11:58 PM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>>>> On Mon, Apr 16, 2012 at 11:11:05PM +0300, Felipe Contreras wrote:
>>>>> On Mon, Apr 16, 2012 at 7:27 PM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>>>>>> Just one minor correction in this looney email thread:
>>>>>>
>>>>>> On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
>>>>>>> v3.3.x on the other hand are *not* stable. They contain patches
>>>>>>> backported from v3.4, but nobody guarantees they will work. There was
>>>>>>> no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
>>>>>>> generally tested together is in v3.3.1, at which point if somebody
>>>>>>> finds issues, it's too late; bad patches are *not* going to be removed
>>>>>>> in v3.3.2.
>>>>>>
>>>>>> Of course there was a 3.3.1-rc1, see the linux-kernel archives for the
>>>>>> announcemen and the individual patches.  kernel.org has the large patch
>>>>>> itself if you like that format instead.
>>>>>
>>>>> I don't see it here:
>>>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=tags
>>>>>
>>>>> If you really want people to try it, why not tag it?
>>>>
>>>> That would be because I don't keep it in that tree.  It is in a quilt
>>>> tree you can find in the stable-queue.git repo, and I have never tagged
>>>> -rc1 releases there.  No one has ever asked for it before, so in the
>>>> past 6 years of stable releases, I guess no one ever needed it.
>>>>
>>>> ketchup and tarballs seem to work well for others, perhaps you can use
>>>> that as well (hint, ketchup on top of the linux-stable tree works just
>>>> fine for testing this.)
>>>
>>> Perhaps the current process will be continue to be OK, but I do
>>> believe a tagged v3.3.1-rc1 would have catched the ath9k issue.
>>
>> How exactly would that have helped here?
>
> More people would have given it a try. Not that many people read the
> mailing list, and the ones that do certainly might want to avoid
> applying a big series of patches; even if their mail client makes it
> easy (mine (Gmail) doesn't). A tag, and an announcement to give a try
> would make it *much* easier.
>
>> You point out:
>>
>>> I used to compile my own kernels and use your stable tree, but this a
>>> new laptop and I was using Arch Linux which automatically updated to
>>> v3.3.1, and with no network I had no way to revert to v3.2.x.
>>> Fortunately I had the kernel sources available, but I wonder how many
>>> people were completely stuck.
>>
>> Arch wouldn't have included a -rc in their kernel (unless they are
>> crazy), so this would not have helped your situation at all.
>
> There's *a lot* of people that got affected by the 3.3.1 release; we
> don't need to break a lot of boxes to figure out there's an issue,
> only a few would suffice, even one.
>
>>> If some other 3.x.1 release get broken this way, I would seriously
>>> consider tagging v3.x.1-rc1 as well. It works for Linus' tree.
>>
>> "this way" was for a very tiny subset of hardware, so odds are, if this
>> happens again, it wouldn't be caught this way either.  That subset just
>> happened to show up in your machine, but, for example, not in the wide
>> range of hardware I test with here, nor the machines that others test
>> with.
>
> It was certainly not just me. I have seen a lot of people mentioning
> "their wifi is broken", a lot of them using Arch Linux,
> coincidentally.
>
> These issues would most likely not be caught before v3.x.1, and which
> point it's too late, they cannot be reverted to v3.x.2 just like that;
> they have to wait for upstream. Hopefully and probably everything
> would go smooth like this time, but maybe not, we'll have to wait and
> see. With more people using Arch Linux and thus the latest "stable"
> release, I'd say we might see an increase in these kinds of issues.
>
> Cheers.
>


on an arch install only a couple months old with one cache cleaning in 
the beginning. the results of packages I could go back to on a bad update.

/var/cache/pacman/pkg $  ls -1 /var/cache/pacman/pkg/linux-*
/var/cache/pacman/pkg/linux-3.2.11-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.12-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.1-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.13-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.14-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.4-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.5-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.6-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.7-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.8-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.2.9-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.3.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-3.3.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-api-headers-3.1.6-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-api-headers-3.3-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.11-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.12-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.1-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.13-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.14-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.4-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.5-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.6-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.7-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.8-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.2.9-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.3.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-docs-3.3.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-firmware-20111101-1-any.pkg.tar.xz
/var/cache/pacman/pkg/linux-firmware-20120205-1-any.pkg.tar.xz
/var/cache/pacman/pkg/linux-firmware-20120227-1-any.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.11-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.12-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.1-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.13-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.14-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.4-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.5-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.6-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.7-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.8-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.2.9-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.3.1-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-headers-3.3.2-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-3.0.17-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-3.0.17-2-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-3.0.19-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-3.0.20-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-3.0.27-1-x86_64.pkg.tar.xz
/var/cache/pacman/pkg/linux-lts-headers-3.0.27-1-x86_64.pkg.tar.xz

yes this lists non relavent packages but shows that it is YOU who does 
not know your distro well enough.

Give up. I am done.. and Felipe NO MORE PRIVATE EMAILS! keep your 
conversations public unless someone asks you to contact them off list
