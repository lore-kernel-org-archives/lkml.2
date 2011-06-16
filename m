Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab1FPSYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:24:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38800 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab1FPSYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=P47YM4U8Moh3xT6fam5/2zZ0EFv4V1cGrSIfryAeJcJi1pEnkGt8CMBntjoqdqAAPv
         fPARgUzijSKCjNEUR3NxBLZ8gqMBrWQviyIEkJDF1AXC1vlMWmJAyYgxJxvNItXx8gQh
         1lzn8DxvyBXuZekzT/619AmJxkg7EDcH+2jHE=
MIME-Version: 1.0
In-Reply-To: <20110616165742.GS20487@llucax.com.ar>
References: <20110616145842.GM20487@llucax.com.ar> <013811$g9fu7@fmsmga002.fm.intel.com>
 <20110616161803.GQ20487@llucax.com.ar> <aefc95$f0ne9@orsmga001.jf.intel.com> <20110616165742.GS20487@llucax.com.ar>
From: =?ISO-8859-1?Q?Ra=FAl_Benencia?= <mail@rbenencia.com.ar>
Date: Thu, 16 Jun 2011 15:24:21 -0300
X-Google-Sender-Auth: W9jBKyZVEVRY9frrOYmfEPv99qU
Message-ID: <BANLkTims0E0jfr+m2GH+k6bc-dvT5FWtSA@mail.gmail.com>
Subject: Re: Graphic corruption with i915 (2.6.39.1)
To: Leandro Lucarella <luca@llucax.com.ar>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/16 Leandro Lucarella <luca@llucax.com.ar>
>
> Chris Wilson, el 16 de junio a las 17:39 me escribiste:
> > On Thu, 16 Jun 2011 13:18:03 -0300, Leandro Lucarella <luca@llucax.com.ar> wrote:
> > > cannot access /sys/kernel/debug/dri/0/i915_error_state: No such file or directory
> > >
> > > The debug directory is not present, should I boot or compile with some
> > > particular option to enable it?
> >
> > You need to compile with CONFIG_DEBUGFS and at runtime
> > "mount -tdebugfs debug /sys/kernel/debug".
> >
> > The /sys/kernel/debug/dri/0/i915_error_state will only be populated
> > after a hang is detected.
>
> OK, I had CONFIG_DEBUGFS but never mounted it. Unfortunately I rebooted
> since the problem, so now that file says: no error state collected
>
> I'll get the contents when it happens again.
>
> --
> Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
> ----------------------------------------------------------------------
> GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
> ----------------------------------------------------------------------
> The world's best known word is "okay"
> The second most well-known word is "Coca-Cola"

I'm having exactly the same problem. It happens pretty randomly, but
I've noticed that the frequency in which it occurs is highly increased
when libflashplayer.so is used. Unfortunately I didn't compile my
kernel with CONFIG_DEBUGFS. I'll change this and if I come across
anything interesting, I'll let you know.

Cheers,
--
Raúl Benencia
