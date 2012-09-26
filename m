Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2IZWFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:05:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1854 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2IZWFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:05:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6847"; a="239382205"
Message-ID: <50637C24.90206@codeaurora.org>
Date: Wed, 26 Sep 2012 15:05:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Brian Swetland <swetland@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, kgdb-bugreport@lists.sourceforge.net,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 08/11] ARM: Move some macros from entry-armv to entry-header
References: <20120924212648.GA27605@lizard> <1348522080-32629-8-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1348522080-32629-8-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/12 14:27, Anton Vorontsov wrote:
> Just move the macros into header file as we would want to use them for
> KGDB FIQ entry code.
>
> The following macros were moved:
>
>  - svc_entry
>  - usr_entry
>  - kuser_cmpxchg_check
>  - vector_stub
>
> To make kuser_cmpxchg_check actually work across different files, we
> also have to make kuser_cmpxchg64_fixup global.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Why can't we put the fiq entry code from the next patch into
entry-armv.S? Sorry if this has been asked before but I don't see any
reasoning in the commit text.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

