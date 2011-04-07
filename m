Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1DGR5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:57:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11999 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1DGR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:57:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6309"; a="84550988"
Message-ID: <4D9DFB08.8090206@codeaurora.org>
Date: Thu, 07 Apr 2011 10:57:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>, Simon Glass <sjg@google.com>
Subject: Re: [PATCH v3] ARM: Use generic BUG() handler
References: <1302131890-20953-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1302131890-20953-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 04:18 PM, Simon Glass wrote:
> From: Simon Glass <sjg@google.com>
>
> ARM uses its own BUG() handler which makes its output slightly different
> from other archtectures.
>
[snip]
>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> ---
>  arch/arm/Kconfig              |    4 +++
>  arch/arm/include/asm/bug.h    |   55 ++++++++++++++++++++++++++++++++++------
>  arch/arm/kernel/traps.c       |   23 +++++++++++++++++
>  arch/arm/kernel/vmlinux.lds.S |    3 +-
>  4 files changed, 75 insertions(+), 10 deletions(-)

Also, have you tried this with a module? I think you would at least need
to modify arch/arm/kernel/module.c to hook up the module_bug_finalize()
and module_bug_cleanup() stuff.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

