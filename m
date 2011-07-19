Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab1GSBvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:51:18 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50632 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1GSBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:51:17 -0400
X-ASG-Debug-ID: 1311040276-082cdab30001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
Message-ID: <4E24E3A1.9080906@marvell.com>
Date: Tue, 19 Jul 2011 09:53:37 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
X-ASG-Orig-Subj: Re: [PATCH 0/2] Add audio sram support
Subject: Re: [PATCH 0/2] Add audio sram support
References: <1310987888-541-1-git-send-email-leoy@marvell.com> <25B60CDC2F704E4E9D88FFD52780CB4C05D3F4F2FA@SC-VEXCH1.marvell.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] Add audio sram support
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05D3F4F2FA@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1311040276
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So i need hold on after SRAM consolidation patches by Russell
has been merged, right?

On 2011年07月18日 21:12, Haojian Zhuang wrote:
> There would be a common sram driver in mainline.
> ________________________________________
> From: Leo Yan [leoy@marvell.com]
> Sent: Monday, July 18, 2011 7:18 PM
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Haojian Zhuang; nicolas.pitre@linaro.org; Russell King
> Cc: Leo Yan
> Subject: [PATCH 0/2] Add audio sram support
>
> On mmp platform, there have 16KB sram buffer dedicated
> to audio island. It can be to dynamically allocated for
> versatile pcm devices. So implement the audio sram
> allocator for managing it.
>
> Leo Yan (2):
>    ARM: mmp: register audio sram device
>    ARM: mmp: add audio sram allocator
>
>   arch/arm/Kconfig                            |    1 +
>   arch/arm/mach-mmp/Makefile                  |    2 +-
>   arch/arm/mach-mmp/audio_sram.c              |  118 +++++++++++++++++++++++++++
>   arch/arm/mach-mmp/brownstone.c              |    1 +
>   arch/arm/mach-mmp/include/mach/audio_sram.h |   31 +++++++
>   arch/arm/mach-mmp/include/mach/mmp2.h       |    6 ++
>   arch/arm/mach-mmp/mmp2.c                    |    1 +
>   7 files changed, 159 insertions(+), 1 deletions(-)
>   create mode 100644 arch/arm/mach-mmp/audio_sram.c
>   create mode 100644 arch/arm/mach-mmp/include/mach/audio_sram.h
>
> --
> 1.7.4.1
>
