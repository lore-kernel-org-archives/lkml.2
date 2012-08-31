Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2HaM0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:26:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59752 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2HaM0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:26:07 -0400
Date: Fri, 31 Aug 2012 14:26:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Marcos Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Get the min and max frequency of a processor
Message-ID: <20120831122616.GA4083@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Marcos Souza <marcos.souza.org@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
 <20120831083727.GA2903@liondog.tnic>
 <CAH0vN5J0_3B2e_dmLk1yaKfCde79egkG-s7THrKtEwzcLnmm5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH0vN5J0_3B2e_dmLk1yaKfCde79egkG-s7THrKtEwzcLnmm5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 06:52:46AM -0300, Marcos Souza wrote:
> Nothing is wrong with access /sys, but I thought there was another
> way, like an API or something else.

Ah, there's no API, AFAICT.

Also, tools/power/cpupower/ uses sysfs too - you could reuse that
code if you don't feel like writing it yourself. The function is
cpufreq_get_hardware_limits()

Ok, technically, there is also a way to query the CPU's MSRs directly
but this is a bit more involved than reading sysfs nodes.

HTH.

-- 
Regards/Gruss,
Boris.
