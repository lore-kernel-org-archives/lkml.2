Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2DPVSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:18:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47360 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2DPVSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120416205856.GA22298@kroah.com>
References: <20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413190819.9469.qmail@stuge.se>
	<CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
	<20120416162710.GA24100@kroah.com>
	<CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com>
	<20120416205856.GA22298@kroah.com>
Date: Tue, 17 Apr 2012 00:18:13 +0300
Message-ID: <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com>
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 16, 2012 at 11:11:05PM +0300, Felipe Contreras wrote:
>> On Mon, Apr 16, 2012 at 7:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > Just one minor correction in this looney email thread:
>> >
>> > On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
>> >> v3.3.x on the other hand are *not* stable. They contain patches
>> >> backported from v3.4, but nobody guarantees they will work. There was
>> >> no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
>> >> generally tested together is in v3.3.1, at which point if somebody
>> >> finds issues, it's too late; bad patches are *not* going to be removed
>> >> in v3.3.2.
>> >
>> > Of course there was a 3.3.1-rc1, see the linux-kernel archives for the
>> > announcemen and the individual patches.  kernel.org has the large patch
>> > itself if you like that format instead.
>>
>> I don't see it here:
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=tags
>>
>> If you really want people to try it, why not tag it?
>
> That would be because I don't keep it in that tree.  It is in a quilt
> tree you can find in the stable-queue.git repo, and I have never tagged
> -rc1 releases there.  No one has ever asked for it before, so in the
> past 6 years of stable releases, I guess no one ever needed it.
>
> ketchup and tarballs seem to work well for others, perhaps you can use
> that as well (hint, ketchup on top of the linux-stable tree works just
> fine for testing this.)

Perhaps the current process will be continue to be OK, but I do
believe a tagged v3.3.1-rc1 would have catched the ath9k issue.
Hopefully that would mean it could have been dropped/reverted for
v3.3.1.

I used to compile my own kernels and use your stable tree, but this a
new laptop and I was using Arch Linux which automatically updated to
v3.3.1, and with no network I had no way to revert to v3.2.x.
Fortunately I had the kernel sources available, but I wonder how many
people were completely stuck.

If some other 3.x.1 release get broken this way, I would seriously
consider tagging v3.x.1-rc1 as well. It works for Linus' tree.

Cheers.

-- 
Felipe Contreras
