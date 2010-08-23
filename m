Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0HWFMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 01:12:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42628 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0HWFMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 01:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BITmi9T4/HTgT55el5TpkhGKzIwBGj86eeA7RUhcVFPP7X/X+0x5bVuo3P/AaVFn/z
         y35RxK4WCeVlccottq8A8ogTylrnhOoQN3oG7O3HUY5bCknVRV8aLgTk25Av/S6moXNh
         YtXf63IOtS7a8c3Vi6OWGNELX3OjE4qBo7OVE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=_XQfC7wGHKWHp7jtYPMKTOwHJkNnvkTddoLK5@mail.gmail.com>
References: <AANLkTi=_XQfC7wGHKWHp7jtYPMKTOwHJkNnvkTddoLK5@mail.gmail.com>
Date: Mon, 23 Aug 2010 01:12:13 -0400
Message-ID: <AANLkTim1fAiqwU9v4B1F+rG91kjV4fkkLPKX0UwBe0Vq@mail.gmail.com>
Subject: Re: [REGRESSION, Radeon-KMS] 2.6.36-rc1 - graphic issues in 0. A.D.
From: Alex Deucher <alexdeucher@gmail.com>
To: trapdoor6@gmail.com
Cc: airlied@linux.ie, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 3:41 PM, trapDoor <trapdoor6@gmail.com> wrote:
> Hello,
> Just wanted to let you know about this before bisecting which
> hopefully I will be able to start tomorrow. Please take a look at the
> screenshots in below links to see the difference with rendering
> textures in 0 A.D. alpha1 on kernel 2.6.35.3 and 2.6.36-rc1-git3. [0
> A.D. - strategic game, OS clone of Age of Empires; home page:
> http://wildfiregames.com/0ad/]
>
> 0 A.D. on kernel 2.6.35.3 [good]:
> http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312214769142226
>
> 0 A.D. on kernel 2.6.36-rc1-git3:
> http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312218519295058
>
> Please note that in both cases only kernel was different. The other
> components [including hardware] were in the same versions and had the
> same options (like the game itself, xorg-ati drivers, mesa, libdrm
> [S3TC disabled], etc.). So it must be kernel then.

What card?  Anything in your dmesg?

Alex
