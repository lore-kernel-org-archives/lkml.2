Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2BWStH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:49:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40191 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2BWStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:49:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of riccardo.magliocchetti@gmail.com designates 10.14.28.137 as permitted sender) smtp.mail=riccardo.magliocchetti@gmail.com; dkim=pass header.i=riccardo.magliocchetti@gmail.com
Message-ID: <4F468A1B.9080408@gmail.com>
Date: Thu, 23 Feb 2012 19:48:59 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: i915 regression with 3.3-rc3+git
References: <4F3EBD0D.7000906@gmail.com> <20120223084106.4b132532@jbarnes-desktop>
In-Reply-To: <20120223084106.4b132532@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Il 23/02/2012 17:41, Jesse Barnes ha scritto:
> On Fri, 17 Feb 2012 21:48:13 +0100
> Riccardo Magliocchetti<riccardo.magliocchetti@gmail.com>  wrote:
>
>> Hello,
>>
>> i've upgraded from 3.2.0-rc7 to post 3.3.0-rc3 git
>> 4903062b5485f0e2c286a23b44c9b59d9b017d53, attached you can find dmesg
>> with drm.debug=0xfff
>>
>> This started to appear in logs:
>>
>> [drm:intel_framebuffer_init] *ERROR* unsupported pixel format
>>
>> X is getting a wrong resolution (log attached) and there's a lot of
>> flickering, if i try to play a video the desktop turns black, the other
>> ttys still works fine though.
>>
>>
>
> Can you check the drm-intel-fixes branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-intel.git?
> It has a fix for laod detection that might help.

3.3-rc4 plus these two patches from drm-intel-fixes works great.

4e9bb47bd29e02f2daaa7bdb2a8ddf977bf76f06 [PATCH 2/2] drm/i915: fix a 
sprite watermark computation to avoid divide by zero if xpos<0
5ca0c34ae28344b6b4ca3036bc82f89c8db16a59 [PATCH 1/2] drm/i915: fix mode 
set on load pipe. (v2)

Thanks!

riccardo



