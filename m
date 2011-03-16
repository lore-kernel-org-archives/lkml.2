Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1CPADH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:03:07 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:51927 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1CPADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:03:03 -0400
Message-ID: <5ddb021757c3aec6d2eda30372a422ee.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTim6H3UCCsT1iAR2O=PL=5K4ypkT7UqcjqbAf3Vp@mail.gmail.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
    <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
    <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
    <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
    <5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
    <20110315112724.6729.qmail@stuge.se>
    <24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
    <AANLkTim6H3UCCsT1iAR2O=PL=5K4ypkT7UqcjqbAf3Vp@mail.gmail.com>
Date: Wed, 16 Mar 2011 01:02:39 +0100 (CET)
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
X-Scan-Signature: c09395f469c52153b963e4ff2d10f427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, March 15, 2011 17:06, Alex Deucher wrote:
> On Tue, Mar 15, 2011 at 7:46 AM, Indan Zupancic <indan@nul.nu> wrote:
>> They don't give their Linux devs any Fusion hardware, nor do they
>> open the UVD spec, but at least they release info like this.
>
> They do give us fusion hw; before launch even.  That's why we had
> Linux support before hw was available publicly.  My board just
> happened to get bricked recently during a failed bios upgrade.
> A new one is on the way.

Okay, that's better than I thought. I remember a dev saying that
no one had Fusion hardware, that's where I got this notion from.

> Also we are looking into a potential release of
> UVD, but unfortunately, our decode hw is intimately tied in with
> our drm implementation and if someone managed to use the released
> information to compromise the drm in our windows driver it would very
> negatively impact our ability to sell into the windows market and
> would probably get the open source graphics initiative shut down.

Are you talking about HDCP or something else? Because the HDCP master
key already leaked, so the whole security aspect of it is already a
joke, open source UVD won't make any difference.

Basically you're telling me that I or someone else should reverse
engineer de Catalyst driver and break all drm before you consider
opening up UVD? I'd argue that opening up UVD now is more secure
because it takes away the only morivation to break UVD's drm.

Alternatively, can't you open up UVD spec except the drm bits,
so people can at least write their own UVD driver to watch
unencrypted data?

It would be nice to have an open source Fusion based media player/
IPTV decoder, but I guess that's hoping for too much.

I understand if AMD/ATI wants to keep its 3D driver secret, but
hardware video decoding?! If you have to keep it secret it means
shortcuts were taken and it's all insecure anyway. That if it gets
broken the Open source driver gets blamed is ridiculous and more
politics than anything else.

This is getting more and more off-topic though, sorry for the noise.

Greetings,

Indan


