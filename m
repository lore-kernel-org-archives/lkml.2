Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3AAUa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 15:30:26 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55662 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3AAUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 15:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+MoWDp7xr9LMguKYmAVcMm_nnco8Lh5KLhWD9eeZ2tc43iNSQ@mail.gmail.com>
References: <CA+MoWDp7xr9LMguKYmAVcMm_nnco8Lh5KLhWD9eeZ2tc43iNSQ@mail.gmail.com>
Date: Tue, 1 Jan 2013 15:30:23 -0500
Message-ID: <CAHdPZaOqy4wnviVJEzAKWa6JN_X0z-zWPo-N1f4gs9O-2EpJ9Q@mail.gmail.com>
Subject: Re: i7-2620M: Clock always high when on battery
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: rob@landley.net, andre.przywara@amd.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 1, 2013 at 3:17 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> I'm not sure if I'm emailing the right people. My problem is with
> dynamic clock and or power management.
>
> I'm using 3.6.10-2.fc17.x86_64 but the exact same problem happen with
> non Fedora Kernels like 3.7.1 and 3.6.11.
>
> I'm using Toshiba R830-10P notebook with i7-2620M cpu.
>
> The problem is that when I power on the notebook without the AC
> adapter the clock of all cores is always very close to 2,7GHz. It was
> expected that without load the clock would be around 800 Mhz. This
> issue is causing the notebook to get hot and reduces battery life. The
> same problem also happens when on AC power but it is uncommon.
>
> What can I do to diagnose the problem and collect more precise details?
>

would you mind trying this

echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

as root?

but before cat that file to see whats the current cpu governor.

> Peter
>
> --
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
