Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0IYK5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:57:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20062 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0IYK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:57:05 -0400
Date: Sat, 25 Sep 2010 12:56:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 2.6.36
Message-ID: <20100925125644.13f6ab91@endymion.delvare>
In-Reply-To: <1285378081-7902-1-git-send-email-guenter.roeck@ericsson.com>
References: <1285378081-7902-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 18:28:01 -0700, Guenter Roeck wrote:
> Hi Linus,
> 
> Please pull hwmon subsystem fixes for Linux 2.6.36 from:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus
> 
> Thanks,
> Guenter Roeck
> 
> ------
> 
> Guenter Roeck (1):
>       MAINTAINERS: Update hwmon entry
> 
> Jan Beulich (7):
>       x86/hwmon: fix module init for hotplug-but-no-device-found case
>       x86/hwmon: avoid deadlock on CPU removal in pkgtemp
>       x86/hwmon: don't leak device attribute file from pkgtemp_probe() and pkgtemp_remove()
>       x86/hwmon: fix initialization of coretemp
>       x86/hwmon: fix initialization of pkgtemp
>       x86/hwmon: register alternate sibling upon CPU removal
>       x86/hwmon: pkgtemp has no dependency on PCI
> 
> Takashi Iwai (1):
>       hwmon: (lis3) Fix Oops with NULL platform data

Thanks a lot for all the review work, Guenter, I appreciate it a lot! I
didn't quite expect you to get up to speed so fast!

-- 
Jean Delvare
