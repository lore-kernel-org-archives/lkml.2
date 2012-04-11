Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab2DKTjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:39:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56938 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2DKTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:39:05 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <201204112135.35891.maciej.rutecki@gmail.com>
References: <201204021939.39603.maciej.rutecki@gmail.com>
	<201204022100.11096.maciej.rutecki@gmail.com>
	<20120402190523.GB5260@phenom.ffwll.local>
	<201204112135.35891.maciej.rutecki@gmail.com>
Date: Wed, 11 Apr 2012 21:39:04 +0200
X-Google-Sender-Auth: 6hwu9OXbicddn-WsGByCAqE0Z4c
Message-ID: <CAKMK7uF6DY-cZTkNn6y5aAqK0WjFJhCfww_BbfgwpNLe8Mio4A@mail.gmail.com>
Subject: Re: [3.4-rc1][Regression][intel] Resume from suspend to disk hangs on
 restoring backlight state
From: Daniel Vetter <daniel@ffwll.ch>
To: maciej.rutecki@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 21:35, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>> > > Patch:
>> > > http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-fixes
>> > > &id= 55a254ac63a3ac1867d1501030e7fba69c7d4aeb
>> > >
>> > > Please test whether this fixes your issue. You can also try adding
>> > > i915.i915_enable_ppgtt=0 to your kernel cmdline.
>> > >
>> > > Thanks, Daniel
>> >
>> > Patch solves problem.
>> >
>> > Now resume hangs later on another subsystem: wireless :D
>>
>> Woot, I'm off the hook ;-) Thanks for reporting this issue and testing the
>> patch.
>>
>> Yours, Daniel
>
> Seems be resolved in -rc2.

My guess is on the firmware load vs. suspend/resume fix that landed in
-rc2. That one fixed resume on all the machines here, and -rc1 broke
it on a lot of them.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
