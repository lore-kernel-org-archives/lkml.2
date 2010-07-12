Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0GLUXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:23:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0GLUXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:23:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VCh/JI7vrI3otFKVVwt+/5dZGhffxLeC0P9s2lM9rhTeyZOT2xTqXXMNVsQ39D+OSp
         23fBPfzN9IPyRO7jLRxsX9XYhEpUmPvJwaD/V8xRbTDOpi6i+aZmI/GI8OkJvZOp+lEa
         OMGImuCvjle296KdW0jeVEcE6ttqjvt2m8REE=
MIME-Version: 1.0
In-Reply-To: <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
	<4C3ABF96.9070405@msgid.tls.msk.ru>
	<AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
	<20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
Date: Mon, 12 Jul 2010 22:23:14 +0200
Message-ID: <AANLkTimWPLqEf4LjHx39zO7yzkJ_c157OjOm3UnBRgJ2@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 3:43 PM, Josef Bacik <josef@redhat.com> wrote:
>
> O_DIRECT support was just introduced recently, please try on the latest kernel
> with the normal settings (which IIRC uses O_DIRECT), that should make things
> suck alot less.  Thanks,
>
> Josef
>
With latest kernel do you mean the current Linus' git tree? Because if
instead you're talking about the current stable kernel, that's the one
I used on my test.

-- 
Giangiacomo
