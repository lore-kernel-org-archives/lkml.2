Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1CZUvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:51:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1CZUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:51:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Sat, 26 Mar 2011 21:51:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103261154.18619.arnd@arndb.de> <AANLkTik7qzFC_WQPrJAMbV0b6-+CTNfP6CcQnK6BKiWn@mail.gmail.com>
In-Reply-To: <AANLkTik7qzFC_WQPrJAMbV0b6-+CTNfP6CcQnK6BKiWn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103262151.47061.arnd@arndb.de>
X-Provags-ID: V02:K0:tSKdrJXBt4iTTPy31z+h5jN3KoJahoILhktW8vE35OK
 h3d/eAGyyvD5qrDPBJE2/BokB2fWGHAs4NSmQ87hn+VTls3Rf7
 AnHU0e4GTBd/dkOMZGcIlY76Zyw3ISDKcAYT7HfwXNIzRve/rN
 T1oqBQ6SA0iZWAkCTQ4gFnOmufDwlJLmgg2MbNdOhI/Fz/BliA
 XTWgKBgXTrKdVdQvNRPtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 March 2011 18:55:39 Mike Frysinger wrote:
> >> i would add an ABI field here too so if in the future we want to add
> >> stuff, we can do so without adding new ioctls.  like "u16 version; u16
> >> flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
> >> the future, we can add flags or bump the version.
> >
> > No, versioned APIs are just a pain to maintain, it's easier to add
> > new ioctl commands when necessary.
> > Note that the kernel would always have to support all versions of
> > the API anyway.
> 
> adding at least a flags field then should be fine

Fine with me, if you can name at least one possible use for a flag.

I think it would be better without a flags field, but it's not a
problem if you insist on having it.

	Arnd
