Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1AQSOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:14:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59562 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1AQSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:14:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MslEjrE1TflJPt82RsyZ/N641IRm3GKImFDuXTNX6C1zZBHffWJWEUp2nyp6XwEODN
         FaACtIavHmFR/xoR0Oaspz6zCfm00I6zGsYkx/u6j/VRK3szfq4TmlX8dFzoZ4g8V9ii
         zEH9nm+i5px8Nl1Xbsh9a1bgKLMFKdFudLA3E=
MIME-Version: 1.0
In-Reply-To: <20110117175555.GA30554@srcf.ucam.org>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
	<20110117175555.GA30554@srcf.ucam.org>
Date: Mon, 17 Jan 2011 11:14:29 -0700
Message-ID: <AANLkTimurinF+Ng+HD0GjtfFgmXnvKPU80_OzVLNNeUA@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 17, 2011 at 10:55 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> I think this needs to be tidied up some more to interact nicely with the
> ec driver, and I'm still a bit concerned that there may be devices of
> the TOS1900 type that implement the old-syle interface but not this one
> (I'll check the files I have here). I'll try to break this up into
> something more generic.

So far I've seen 3 types of TOS1900 devices

1 - The ones that the ENAB call is sufficient to enable hotkeys

2 - Another kind using HCI_HOTKEY_EVENTS call (and using
the EC to access the NTFY method)

3 - My current laptop (Qosmio X505) which the ENAB and/or
the HCI_HOTKEY_EVENTS calls don't work...

I've already asked Toshiba for info on this, but there's no ETA
on when I'll get it.


Saludos
Azael Avalos



-- 
-- El mundo apesta y vosotros apestais tambien --
