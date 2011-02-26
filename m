Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1BZXjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:39:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:42946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1BZXjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:39:03 -0500
Message-ID: <4D698F12.6030205@suse.com>
Date: Sat, 26 Feb 2011 18:38:58 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Add ``cloneconfig'' target
References: <4D671556.80607@suse.com>	<20110225060706.GA12723@merkur.ravnborg.org>	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>	<AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>	<AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>	<AANLkTik0VoCSHbpZ=CqG8ZoBNKVQuOEKf3bf19uz-tjj@mail.gmail.com> <AANLkTi=+PD9jTMJ+MsB0S+ESmN97O69HosbuVB7fgaQN@mail.gmail.com>
In-Reply-To: <AANLkTi=+PD9jTMJ+MsB0S+ESmN97O69HosbuVB7fgaQN@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/26/2011 06:26 PM, Arnaud Lacombe wrote:
> Hi,
> 
> On Sat, Feb 26, 2011 at 6:16 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Sat, Feb 26, 2011 at 11:57 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> On Sat, Feb 26, 2011 at 5:47 PM, Miguel Ojeda
>>> <miguel.ojeda.sandonis@gmail.com> wrote:
>>>> /proc/config.gz is provided by the kernel and its format is defined by
>>>> kconfig itself which is, as well, part of the kernel (it is not one
>>>> random format from a pool of a trillion), so it will be nice if
>>>> kconfig learns how to read its own configuration from there.
>>>>
>>> your point being ? kconfig is not only used by the Linux kernel, and
>>> you cannot expect the feature to only be used in the cozy Linux kernel
>>> environment.
>>
>> My point was that supporting reading from a .gz file is not anywhere
>> near "knowing about the trillion file format which exist in the world"
>>
> Well, Jeff's patch is already about gzip and bzip2. Soon it will be
> compress, xz, zip, rar, then rzip, lzma, 7z ...

I added bzip2 as an exercise. But realistically, what would be wrong
with distributors deciding to ship /boot/config-$UNAME_RELEASE.bz2 and
saving a bit of valuable /boot disk space?

Even if people /do/ submit patches do do all of those formats, your
argument is based on the premise that having that ability is necessarily
bad. I don't think we need them, but I don't think it's a good argument
against this patch either.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1pjxIACgkQLPWxlyuTD7Jm3wCfSG6z1aBOT6PDLVmQeycW5mmM
Z/IAoJJXW7P5C+cWg8lFSTmm+HtBjR0E
=b5Hc
-----END PGP SIGNATURE-----
