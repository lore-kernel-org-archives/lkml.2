Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1CFUZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:25:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60978 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1CFUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YrwozNQbYPeQVEG3KMDxY3Uc9D8mS/jwZUklAUFqLoN1SQzrGQVNFlEyIG9a80ymHl
         9Jt521DEZBR8r5f2JrFlxwZb9HQ+IRq9vApZz0eqv4Rr/vN4EuMWEaYw1T+LCvjGgeb6
         8UjorocqaMV3b1MVf747NFbOu4MLXWg7Ehgn4=
MIME-Version: 1.0
In-Reply-To: <201103062020.21959.Martin@lichtvoll.de>
References: <201103051510.35057.Martin@lichtvoll.de>
	<AANLkTi=3HwdHdQzoLUDebfAAMKwSQvVZ43_eQDfi1iB+@mail.gmail.com>
	<201103061929.23007.Martin@lichtvoll.de>
	<201103062020.21959.Martin@lichtvoll.de>
Date: Mon, 7 Mar 2011 06:25:34 +1000
Message-ID: <AANLkTinhx12_HvDq3Mp7xrkrCez90pNiSuh7KrJAmFXp@mail.gmail.com>
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks
 up hard when using desktop cube of kwin
From: Dave Airlie <airlied@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I verified this. Lockup happens with 2.6.38, last one tested rc8-gfb62c00,
> but not with 2.6.37 with exactly same userspace. Needed to try the effect
> several times, as this time the lockup with 2.6.38 only happened shortly
> after the second activation of the effect.
>

Hmm, can you attach Xorg logs from both?

I'm guessing its either pageflipping or a later kernel allowing some
feature of mesa to be used.

Dave.
