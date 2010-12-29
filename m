Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0L2WC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 17:02:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0L2WC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 17:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VIT02oY0Wk1P/HUli0VDpzNB9iRpVLzXVCwUoim3EIAgl2FoYMPxdkbLTwa5UfwJvp
         SDn6HmqoNSrdnRa3lZ1s8i6YIiiZNdF5QDfTAuN7JNbKS7mxezOB/n3NJsS4dphKzC1d
         fOxPOmVza//HiT8XFqQYwriGTUXXXZWpeJEmg=
MIME-Version: 1.0
In-Reply-To: <20101229131852.0792aac0@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
Date: Wed, 29 Dec 2010 23:02:55 +0100
Message-ID: <AANLkTimLoPDCz3Px3Da0SouqCbF1V=yckqr0wd0vNEh7@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 22:18, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > +               if (IS_GEN5(dev) || IS_GEN6(dev))
>> > +                       dev_priv->lvds_use_ssc = 0;
>>
>> Doesn't change anything here. Display stays blank.
>
> Sounds like your problem is separate from SSC then, more likely related
> to panel power or backlight control.  Have you tried bisecting for the
> problem between 2.6.35 and 2.6.36?

No. I assumed the bisection in the bug

  https://bugzilla.kernel.org/show_bug.cgi?id=22672

was for the same problem as mine. It probably is not...
I'm running a bisect right now.
