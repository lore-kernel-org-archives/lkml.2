Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1COQGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:06:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40306 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab1COQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N8CNe2Tra9oHUXHgjnDmxyF5htyJtzuIJYsJo2lNK3JZ1cdeqWvaXnqy2RUfb+Dc5x
         7Ohd4usHbsrjZHcCuUR+VYAuAt4E/jS5cQSvT+mZQwMECqSVa2fHc36NnaluD49dRC20
         myyuiA4hMg2TPGZiADJayGrU+EbKmlauyN+vM=
MIME-Version: 1.0
In-Reply-To: <24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
	<cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
	<b7da2f$qnp1ps@fmsmga001.fm.intel.com>
	<5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
	<20110315112724.6729.qmail@stuge.se>
	<24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
Date: Tue, 15 Mar 2011 12:06:04 -0400
Message-ID: <AANLkTim6H3UCCsT1iAR2O=PL=5K4ypkT7UqcjqbAf3Vp@mail.gmail.com>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: Alex Deucher <alexdeucher@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 7:46 AM, Indan Zupancic <indan@nul.nu> wrote:
> On Tue, March 15, 2011 12:27, Peter Stuge wrote:
>> coreboot has existed for about eleven years and some 250 mainboards of
>> varying shapes and sizes (from laptop to server) are supported, but it's
>
> I've been wanting to get rid of BIOSes and use Coreboot for ages,
> but the amount of hassle needed to get it working for my hardware
> and the lack of features (suspend), as well the chance of bricking
> the system always put me off.
>
>> only just recently that things are really taking off, with the code
>> release from AMD to initialize their most recent Fusion platform.
>
> They don't give their Linux devs any Fusion hardware, nor do they
> open the UVD spec, but at least they release info like this.
>

They do give us fusion hw; before launch even.  That's why we had
Linux support before hw was available publicly.  My board just
happened to get bricked recently during a failed bios upgrade.  A new
one is on the way.  Also we are looking into a potential release of
UVD, but unfortunately, our decode hw is intimately tied in with our
drm implementation and if someone managed to use the released
information to compromise the drm in our windows driver it would very
negatively impact our ability to sell into the windows market and
would probably get the open source graphics initiative shut down.

Alex

> Greetings,
>
> Indan
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
