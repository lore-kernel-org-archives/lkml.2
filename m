Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1CPOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:11:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1CPOLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nk9Isn7CqHxAb8+s9pfDhB8oz3lbQnud0gQySw02+zY95jH7A7uWUjcdvlBhNZqjgW
         cUYDpdbTkGA5rYiMQxiHnK6fZTrevnIicXbs97oGNIKBPCuN1vtxoDuoGE3HgRDWaYXD
         GHSoj/L2JYbEE7ZkJh5jpiI2cjO+ogLlNVy1Y=
MIME-Version: 1.0
In-Reply-To: <b8251956140564bbc4fdec9b4be7e8eb.squirrel@webmail.greenhost.nl>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
	<cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
	<b7da2f$qnp1ps@fmsmga001.fm.intel.com>
	<5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
	<20110315112724.6729.qmail@stuge.se>
	<24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
	<AANLkTim6H3UCCsT1iAR2O=PL=5K4ypkT7UqcjqbAf3Vp@mail.gmail.com>
	<5ddb021757c3aec6d2eda30372a422ee.squirrel@webmail.greenhost.nl>
	<AANLkTim1JrkhXyQgp3=BU=9uWEN2D7QQg-DJdTk1wEzL@mail.gmail.com>
	<b8251956140564bbc4fdec9b4be7e8eb.squirrel@webmail.greenhost.nl>
Date: Wed, 16 Mar 2011 10:11:13 -0400
Message-ID: <AANLkTiku-9+EJc4yBdTYWLmF5QUsrxAB4ma1vpjFdqFK@mail.gmail.com>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: Jerome Glisse <j.glisse@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Alex Deucher <alexdeucher@gmail.com>, Alan Cox <alan@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Matthew Garrett <mjg@redhat.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 2:26 AM, Indan Zupancic <indan@nul.nu> wrote:
> On Wed, March 16, 2011 03:17, Alex Deucher wrote:
>> It's not HDCP, encrypted bluray is the main issue.  And while
>> there are hacks for bluray around already, contractual obligations
>> don't care whether existing hacks are available or not.
>
> So the contract says to keep it secret, not to make it secure.
> Wonderful.
>
>> Without going into detail, they are very intertwined.  The hw was
>> designed long before we planned to support open source as much as we
>> are now.  Fortunately, we have been working with our hw teams to make
>> future UVD implementations take the open source driver into account.
>
> It has nothing to do with open source, if you need to trust the
> driver you're already screwed from a security point of view.
>
>>>
>>> It would be nice to have an open source Fusion based media player/
>>> IPTV decoder, but I guess that's hoping for too much.
>>>
>>> I understand if AMD/ATI wants to keep its 3D driver secret, but
>>> hardware video decoding?! If you have to keep it secret it means
>>> shortcuts were taken and it's all insecure anyway. That if it gets
>>> broken the Open source driver gets blamed is ridiculous and more
>>> politics than anything else.
>>
>> We don't keep the 3D engine secret.  Most of the code we've written
>> and specs we've released are 3D engine stuff.  Fortunately 3D is less
>> tied up in drm compared to video.
>
> That's not what I said, I was talking about the driver. There are always
> details not documented, and plenty of optimisation tricks that make the
> hardware go fast. Just compare the performance of the Windows driver
> with the open source Linux driver. It doesn't give the impression that
> AMD is putting much effort in the open source drivers or that it takes
> it seriously.

People are over thinking and believe secret recipes is what actually
make driver fast. From my experience i would say that it's just the
open source driver stack that is limiting performances, mostly because
it require a huge amount of work. I believe there is several hundred
of engineers working on the closed driver just to optimize it and
improve it while the open source stacks have couple dozen and not all
working on same hw but working on AMD, Intel, NVidia.

You can check that with some of the test that were in r600 demo, iirc
correctly with direct hw access perf were close to theoretical hw
performance.

Cheers,
Jerome
