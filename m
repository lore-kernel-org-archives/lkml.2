Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2I1B1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:27:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60816 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2I1B1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:27:32 -0400
Message-ID: <5064FCFE.4070009@gmail.com>
Date: Fri, 28 Sep 2012 03:27:26 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hot CPU with 3.6.0-rc7+ and intel graphic
References: <506473D8.10904@gmx.de>
In-Reply-To: <506473D8.10904@gmx.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.2012 17:42, Toralf Förster wrote:
> I'm observing a high CPU usage at my ThinkPad T420 (i5-2540M CPU), w/
> integrated intel graphic.
> 
> Powertop-2.1 shows that the GPU is always at 100%, although I've defined
> these settings :
> $> cat /etc/modprobe.d/i915.conf
> options i915 i915_enable_rc6=7 lvds_downclock=0
> 
> Kernel 3.5.4 works fine, I don't see any differences in dmesg output.

Could you try to bisect this problem?


Daniel


