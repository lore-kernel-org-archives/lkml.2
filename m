Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0LTVws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:52:48 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16491 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab0LTVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:52:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67612264"
Message-ID: <4D0FD02E.3080901@codeaurora.org>
Date: Mon, 20 Dec 2010 13:52:46 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking assembly
 volatile
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>	<1292875718-7980-1-git-send-email-sboyd@codeaurora.org>	<1292875718-7980-2-git-send-email-sboyd@codeaurora.org> <AANLkTi=8F3keaAQ2o+V8gNncNM02c9k9=DRtd5GyP_LH@mail.gmail.com>
In-Reply-To: <AANLkTi=8F3keaAQ2o+V8gNncNM02c9k9=DRtd5GyP_LH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 01:49 PM, Arnaud Lacombe wrote:
> Hi,
>
> On Mon, Dec 20, 2010 at 3:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Without marking the asm __dcc_getstatus() volatile my compiler
>> decides [...]
> What compiler ? That might be a usefull information to know,
> espectially 5 years from now when tracing code history. There has been
> similar issue with gcc 4.5 recently. AFAIK, in the same idea, the
> final change has been to mark the asm volatile.

Sure, we can replace "my compiler" with "my compiler (arm-eabi-gcc (GCC)
4.4.0)".

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

