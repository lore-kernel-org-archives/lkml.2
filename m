Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2GYIyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:54:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GYIy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:54:29 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and XWindow
Date: Wed, 25 Jul 2012 10:54:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3; KDE/4.8.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
References: <201207251020.47637.maciej.rutecki@gmail.com> <20120725082926.GB5396@phenom.ffwll.local>
In-Reply-To: <20120725082926.GB5396@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207251054.25498.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 25 lipca 2012 o 10:29:26 Daniel Vetter wrote:
> On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
> > Last known good: 3.4.4
> > First bad: 3.5.0
> > 
> > When booting 3.5.0 resolution (in console, and after in KDE) is set to
> > 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).
> 
> Can you please attach the output of xrandr --verbose for both kernels?
> Also, please boot with drm.debug=0xe added to your kernel cmdline and grab
> the dmesg (again for both kernels).
> 

Thanks for the ansfer.

Here xrandr and dmesg outputs for 3.4.4 and 3.5.0

http://mrutecki.pl/download/kernel/3.5/swinka/debug/

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
