Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1CPG1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:27:30 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42360 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1CPG1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:27:24 -0400
Message-ID: <b8251956140564bbc4fdec9b4be7e8eb.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTim1JrkhXyQgp3=BU=9uWEN2D7QQg-DJdTk1wEzL@mail.gmail.com>
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
Date: Wed, 16 Mar 2011 07:26:57 +0100 (CET)
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Deucher" <alexdeucher@gmail.com>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "Matthew Garrett" <mjg@redhat.com>, "Len Brown" <lenb@kernel.org>,
        "Alan Cox" <alan@linux.intel.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 2c269fdec788119c0964d98755c55204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 16, 2011 03:17, Alex Deucher wrote:
> It's not HDCP, encrypted bluray is the main issue.  And while
> there are hacks for bluray around already, contractual obligations
> don't care whether existing hacks are available or not.

So the contract says to keep it secret, not to make it secure.
Wonderful.

> Without going into detail, they are very intertwined.  The hw was
> designed long before we planned to support open source as much as we
> are now.  Fortunately, we have been working with our hw teams to make
> future UVD implementations take the open source driver into account.

It has nothing to do with open source, if you need to trust the
driver you're already screwed from a security point of view.

>>
>> It would be nice to have an open source Fusion based media player/
>> IPTV decoder, but I guess that's hoping for too much.
>>
>> I understand if AMD/ATI wants to keep its 3D driver secret, but
>> hardware video decoding?! If you have to keep it secret it means
>> shortcuts were taken and it's all insecure anyway. That if it gets
>> broken the Open source driver gets blamed is ridiculous and more
>> politics than anything else.
>
> We don't keep the 3D engine secret.  Most of the code we've written
> and specs we've released are 3D engine stuff.  Fortunately 3D is less
> tied up in drm compared to video.

That's not what I said, I was talking about the driver. There are always
details not documented, and plenty of optimisation tricks that make the
hardware go fast. Just compare the performance of the Windows driver
with the open source Linux driver. It doesn't give the impression that
AMD is putting much effort in the open source drivers or that it takes
it seriously.

> It's all about mitigating risk.
> Imagine you run a company and someone asks you this:  "Can we release
> programming info for a part of our chip to support 2-3% of our market
> that may put at risk 90% of our market?"  What would you do?  The
> reason the review is taking so long is that we want to be real sure
> that the risk is safe.

That's what AMD doesn't get, it only has 2-3% because its drivers
aren't great. If AMD had good performing open source drivers they
would not only get a bigger market share, their hardware would also
be used more for embedded kind of things like decoders, media boxes
and who knows what.

The risk you're talking about is how to best hide that the hardware
is totally insecure as far as the drm goes. Well no, you wouldn't
want to make that public indeed. It's probably the crazy drm's that
more or less forced AMD to implement it this way, but still.

>>
>> This is getting more and more off-topic though, sorry for the noise.
>
> Agreed.

Last post from me about this...

Greetings,

Indan


