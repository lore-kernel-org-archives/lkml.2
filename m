Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2CZXJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:09:12 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57631 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2CZXJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:09:11 -0400
From: Kevin Hilman <khilman@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: mathieu.poirier@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 9/9] ARM: omap: select CPU_FREQ_TABLE where needed
Organization: Texas Instruments, Inc.
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
	<1332522836-29517-10-git-send-email-mathieu.poirier@linaro.org>
	<20120323182746.GF9859@atomide.com>
Date: Mon, 26 Mar 2012 16:09:07 -0700
In-Reply-To: <20120323182746.GF9859@atomide.com> (Tony Lindgren's message of
	"Fri, 23 Mar 2012 11:27:46 -0700")
Message-ID: <87limnq7sb.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:17]:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> The omap platform requires CPU_FREQ_TABLE support to be enabled for its
>> CPU_FREQ implementations, so automatically select that when CPU_FREQ
>> is enabled.
>
> I think this is also solved now, Kevin might be able to confirm this.

Yes, this is solved in mainline by selecting it from
drivers/cpufreq/Kconfig.arm

Kevin
