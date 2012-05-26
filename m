Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2EZHsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:48:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2EZHsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:48:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL]: dma-buf updates for 3.5
Date: Sat, 26 May 2012 07:48:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@linux.ie>
References: <CAO_48GFE3=yQjKS4w7=pGjNe3yENbRrd4bcMTfADJSn7LKekPQ@mail.gmail.com> <CAO_48GGRRvCKVyY_s=oFgTb1vfjf8pSkHRf3jA8iFcdEHhwxVg@mail.gmail.com> <CA+55aFy9QysTkgPuy=GPxknRMoPTSTmp3FkHFJ+bs0G6CSh41g@mail.gmail.com>
In-Reply-To: <CA+55aFy9QysTkgPuy=GPxknRMoPTSTmp3FkHFJ+bs0G6CSh41g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205260748.29800.arnd@arndb.de>
X-Provags-ID: V02:K0:OvHmS9CLjuiqiRiW3cn+rYsNz9PXMVent8vMUb6+2q8
 G3svUscIG5d6KeZCexDzNnzr8fex3hnt5yVnZ1BVK47+Au5ezk
 XtfQCQ1phIAqHjoBxRY5vvZBf/rtW8XdD/YkL5WPysDTHnPGwz
 zRSg5nQGDWKENVgEMIeGFOUy2HwZP8INSyut59EBlSUK0lyzTr
 eZJbYgeCX09zqtFop3MN3gwfTU6rJLZ3xoHcowJY2Q4tHauomz
 TLz58g8aeA1z3UkWOaeLR56mgphFCkhi6nSLctZjmz/56Jqh+2
 CBdgSniaBxic1CeGLRG/lPFovH51wfOyIu6J2+xf+/hu8A3Dqs
 UqB7mfA6U1LY62KD0BoM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2012, Linus Torvalds wrote:
> Please do something like
> 
>    gpg --keyserver pgp.mit.edu --send-keys 7126925D
> 
> to actually make your public key public.
> 
> Of course, if it isn't public, I assume it hasn't actually been signed
> by anybody, which makes it largely useless. But any future signing
> action will validate the pre-signing uses of the key, so that's
> fixable.

We have a Linaro meeting this week, so we will make sure to get this
key and other relevant ones signed by everyone who is here and in the
kernel keyring.

	Arnd
