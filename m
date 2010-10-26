Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0JZTsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:48:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39941 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0JZTsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=si9AZiLI/h11vbYAoR+51Z+X4itQ8w8ZEGutfyq4qbjPNZy7Q4PjOndm74dUlWX0JZ
         5f6OHv1ksspD1Vu05dsu/Dm+2heWfz+E9Q6olLrzmvsx7UZpEimU8WZ0IsN/gHitWAgt
         UnJQGqFIAvzs1T+aSb5EgHOxuzZGbRKUOSCk8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimHpyJho6AheQc6zos7Pmr-ECjvaL83mYDC19Yd@mail.gmail.com>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
	<20101026123552.GA4604@sig21.net>
	<AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
	<20101026184123.GA1616@sig21.net>
	<AANLkTimHpyJho6AheQc6zos7Pmr-ECjvaL83mYDC19Yd@mail.gmail.com>
Date: Tue, 26 Oct 2010 21:48:12 +0200
Message-ID: <AANLkTi=TPCXXki3jrrFA1HiauDp0rZVtMK9fK4z8B_kv@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-10-25 is baked
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Stezenbach <js@sig21.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> Well so just
>> But according to
>> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002175.html
>> the compat-rt2x00 tarballs seem to be made manually?
>
> Too lazy to check that, best thing might be to just focus on upstream
> development, ensuring patches get into linux-next.git and having your
> users just use the daily tarballs and stable releases for stable
> stuff.

The compat-rt2x00 package only contains the experimental patches,
which are not always ready for upstream usage. It exists for testing purposes.
Not all patches inside the experimental tree will be moved upstream,
they often cause a lot of crashes and are often incomplete.
Basically the package only exists for some people who want to test
the latest rt2x00 code the first.  The mac80211 code inside the package
usually lags a few days behind compat-wireless, simply because I
don't always care for the latest mac80211 version. ;)

>> Sorry for stupid questions, I want to get into rt2x00 development
>> but I need to target a stable 2.6.32 kernel and I'm trying to figure
>> out which git tree to base my work on.
>
> My advice, work on wireless-testing.git, send patches ASAP, and let
> them propagate. Use the daily tarballs for user testing and for stable
> release you can support users using the stable compat-wireless
> releases.

For rt2x00 development you can choose between rt2x00.git and
wireless-testing.git,
the trees are usually not that far apart, since smaller patches are pushed quite
quickly upstream. (Also rt2x00.git is rebased frequently, while
wireless-testing.git rarely
is rebased)

Ivo
