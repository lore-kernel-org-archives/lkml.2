Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2GYI3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:29:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2GYI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:29:19 -0400
Date: Wed, 25 Jul 2012 10:29:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and
 XWindow
Message-ID: <20120725082926.GB5396@phenom.ffwll.local>
Mail-Followup-To: Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <201207251020.47637.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207251020.47637.maciej.rutecki@gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
> Last known good: 3.4.4
> First bad: 3.5.0
> 
> When booting 3.5.0 resolution (in console, and after in KDE) is set to 
> 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).

Can you please attach the output of xrandr --verbose for both kernels?
Also, please boot with drm.debug=0xe added to your kernel cmdline and grab
the dmesg (again for both kernels).

Thanks, Daniel

> 
> Dmesg from 3.5.0:
> http://mrutecki.pl/download/kernel/3.5/swinka/dmesg-3.5.0.txt
> 
> Dmesg from 3.4.4:
> http://mrutecki.pl/download/kernel/3.5/swinka/dmesg-3.4.4.txt
> 
> Config 3.5.0:
> http://mrutecki.pl/download/kernel/3.5/swinka/config-3.5.0
> 
> lspci:
> http://mrutecki.pl/download/kernel/3.5/swinka/lspci.txt
> 
> Regards
> -- 
> Maciej Rutecki
> http://www.mrutecki.pl
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
