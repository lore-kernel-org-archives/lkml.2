Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab1IIIpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:45:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50419 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1IIIpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <yunfwk7d75x.fsf@aiko.keithp.com>
References: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
	<yunfwk7d75x.fsf@aiko.keithp.com>
Date: Fri, 9 Sep 2011 10:45:45 +0200
Message-ID: <CAJJYPdmY75GQVtaq0PsuFkngsR-5NepCZ38dv3_CL65QQM-WLA@mail.gmail.com>
Subject: Re: [Intel-gfx] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3459
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/8 Keith Packard <keithp@keithp.com>:
> On Wed, 7 Sep 2011 22:50:02 +0200, Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>> Hi
>>
>> This happened to today probably in the moment, LCD was turned off by
>> Xserver as a screenblank
>> My hw is Lenovo T61  4GB, intel driver.
>
> Can you describe what your desktop software environment looks like? Are
> you running mutter, or compiz or some other compositing window manager?
> Were you running a full-screen game? In other words, could you have been
> hitting the page-flipping paths with a full-screen 3D application?
>


Hard to tell whether it's desktop environment - but it's so called Gnome3.
Desktop/CPU was mostly idle - maybe some Firefox  animation running on
the screen,
but yes it's full-screen 3d desktop.

Zdenek
