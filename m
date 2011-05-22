Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1EVAyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 20:54:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1EVAyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 20:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=e7lXXjCj9POPs8wg9wKpRE9n4k+cx//LB+WqaDxNzGfd6SONZlT0+/Z6Gtgr5JvShL
         T+riGG6Wf7TPXKWWOVCdapjHC2NxHDEgQyl7YA8BdrJkITc7hT8g19SPwQLTh+D2cHHY
         XhDF6A4tt+W/lHhCYrwwBWW8JK7TFbGLfvimM=
MIME-Version: 1.0
In-Reply-To: <201105211032.51222.arnd@arndb.de>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
 <4DD6FB9E.2050604@tilera.com> <BANLkTin5cE-u-J_88UC6ROxvwiMxR6Ro-Q@mail.gmail.com>
 <201105211032.51222.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 21 May 2011 17:54:17 -0700
Message-ID: <BANLkTik-d3ip3R42=fRyjFav2SeXfki=ng@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 01:32, Arnd Bergmann wrote:
> On Saturday 21 May 2011 09:46:55 Eric Biederman wrote:
>> What is wrong with an mtd driver?
>>
>> Looking a bit back into the conversation it appears clear that you are
>> talking about something that resembles NOR flash with multiple sectors,
>> etc.
>>
>> eeproms have random byte access and are typically 256 bytes.  You devices
>> doesn't sound anything like an eeprom.
>
> MTD implies that you have low-level access to the NOR flash registers,
> which this one doesn't. It's certainly not the right Linux interface
> for a high-level flash device, and there is no precedent for this at
> all in Linux.
>
> We do have precedent for multiple interfaces that have the same
> purpose as this one:
>
> drivers/misc/eeprom/*
> drivers/char/ps3flash.c
> drivers/char/nwflash.c
> drivers/char/bfin-otp.c

there is a new otp framework in the works that this driver would move
to.  but that wouldnt matter to the driver being proposed for the tile
arch i dont think.
-mike
