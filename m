Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1GLHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:33:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39423 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1GLHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110705230101.GD2852@fujiko>
References: <20110621142133.GA3652@fujiko>
	<yunhb7jxkz2.fsf@aiko.keithp.com>
	<20110621155205.GA2488@fujiko>
	<yunboxrxiz2.fsf@aiko.keithp.com>
	<20110621164209.GA2155@fujiko>
	<yun8vsvxdr4.fsf@aiko.keithp.com>
	<20110621184757.GA2185@fujiko>
	<yunzklb9fg1.fsf@aiko.keithp.com>
	<20110705230101.GD2852@fujiko>
Date: Tue, 12 Jul 2011 10:33:06 +0300
X-Google-Sender-Auth: Ut7IppOyYzmmU0L0lEBsXVPBSa8
Message-ID: <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
Subject: Re: Reverting rc6 by default
From: Pekka Enberg <penberg@kernel.org>
To: Francesco Allertsen <fallertsen@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 2:01 AM, Francesco Allertsen
<fallertsen@gmail.com> wrote:
> On Tue, Jun 21, 2011 at 12:01:34PM -0700, Keith Packard wrote:
>> Thanks. I'll see if I can't get an X201s upgraded to this version and
>> see if we can reproduce the problem you're having...
>
> Any news?
>
> I have found the time today for more debugging.
>
> Attached there are 3 files.
>
> dmesg-startup is the startup of the last 3.0.0-rc6 kernel, with the
> debug enabled.
> dmesg-enabled is the X startup (and freeze) with debug mode and rc6
> enabled.
> dmesg-disabled is the X startup with debug mode enabled and rc6 disabled
> (so no freeze; full kde startup and logout).
>
> I hope this helps you to solve the problem, otherwise the X201s users
> will not use the 3.0.0 kernel :-(.
>
> If you need more informations just let me know.

AFAICT, this problem is still there in 3.0-rc7. Keith, isn't it time
to revert commit a51f7a6 ("drm/i915: enable rc6 by default") before
3.0 is out?
