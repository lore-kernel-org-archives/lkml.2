Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2KGOmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:42:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33768 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2KGOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:42:43 -0500
Message-ID: <509A735E.4080103@ti.com>
Date: Wed, 7 Nov 2012 08:42:38 -0600
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joshua Emele <jemele@gmail.com>
CC: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-omap@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cpufreq: OMAP: if available, scale the iva coprocessor
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
In-Reply-To: <1352252861-18384-1-git-send-email-jemele@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 November 2012 07:47 PM, Joshua Emele wrote:
> The iva coprocessor, available on some omap platforms, shares a voltage domain
> with the mpu. If cpufreq is active and the mpu processor is scaled down, the iva
> coprocessor should also be scaled. The goal is to make sure we do not ramp down
> the voltage on the domain and affect clocking on the iva coprocessor leading to
> a dsp crash.
>
> I only have access to an omap3evm-ish device, so I do not know what the iva
> clock name is for omap24xx and omap44xx. This detail can be added later if the
> general approach is approved.
>
> I have tested a version of this patch against the linux-3.3 kernel, so this my
> attempt at a forward port against the current mainline. I have based my patch
> series against linux-omap-pm/pm-next.
>
How about making use of CPUFREQ notifiers to handle it. I don't like
this series since it adds multi-media co-processor scaling into the
CPUFreq driver.

Regards
Santosh
