Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0GLNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:34:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61548 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0GLNeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IsMzFMHSPR1n3lY3vAYcFKjrPGF1/4H0z51AeMFLoRdSF0SoftVgb8Ah8sW++m5li6
         jlptqk5KNtrY5NVUsHPBLJIEDVPzvBpFv09b6gIcYQTuY9RDR0xgoNVAe+A5aUvw7r+W
         bWK2FOKZmIHd97ySHUFPiQOgMyZSU6XeHyx3k=
MIME-Version: 1.0
In-Reply-To: <4C3ABF96.9070405@msgid.tls.msk.ru>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
	<4C3ABF96.9070405@msgid.tls.msk.ru>
Date: Mon, 12 Jul 2010 15:34:44 +0200
Message-ID: <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 9:09 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> This looks quite similar to a problem with ext4 and O_SYNC which I
> reported earlier but no one cared to answer (or read?) - there:
> http://permalink.gmane.org/gmane.linux.file-systems/42758
> (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
> try a few other options, esp. cache=none and re-writing some guest
> files to verify.
>
> /mjt
>
Either way, changing to cache=none I suspect wouldn't tell me much,
because if it's as slow as before, it's still unusable and if instead
it's even slower, well it'd be even more unusable, so I wouldn't be
able to tell the difference. What I can say for certain is that with
the exact same virtual hd file, same options, same system, but on an
ext3 fs there's no problem at all, on a Btrfs is not just slower, it
takes ages.

-- 
Giangiacomo
