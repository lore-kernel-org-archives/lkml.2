Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2KMRqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:46:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39154 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2KMRp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:45:59 -0500
Message-ID: <50A28749.5040103@ti.com>
Date: Tue, 13 Nov 2012 13:45:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <gregkh@linuxfoundation.org>, <b-cousson@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] staging: omap-thermal fixes
References: <1352821402-13458-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1352821402-13458-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

I will repost this series as I found I sent you wrong set of patches.

Please check the next version.

On 13-11-2012 11:43, Eduardo Valentin wrote:
> Hello Greg,
>
> Several compilation fixes and a couple of debugging prints
> added to the omap-thermal driver under staging area.
>
> Patches are also available here:
>
> git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes
>
> Cheers,
>
> Eduardo Valentin (4):
>    staging: omap-thermal: fix compilation
>    staging: omap-thermal: remove platform data nomenclature
>    staging: omap-thermal: remove freq_clip table
>    staging: omap-thermal: add IRQ debugging messaging
>
> Radhesh Fadnis (1):
>    staging: omap-thermal: fix context restore function
>
>   drivers/staging/omap-thermal/omap-bandgap.c        |   63 ++++++++----------
>   drivers/staging/omap-thermal/omap-bandgap.h        |    9 ---
>   drivers/staging/omap-thermal/omap-thermal-common.c |   69 ++------------------
>   3 files changed, 34 insertions(+), 107 deletions(-)
>

