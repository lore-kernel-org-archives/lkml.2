Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0LHUa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:30:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52476 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0LHUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:30:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6191"; a="65828937"
Message-ID: <4CFFEB00.5090807@codeaurora.org>
Date: Wed, 08 Dec 2010 12:30:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Arve Hj?nnev?g <arve@android.com>
Subject: Re: [PATCHv3 2/4] ARM: Allow machines to override __delay()
References: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>	 <1291783128-27520-3-git-send-email-sboyd@codeaurora.org>	 <1291836162.12568.17.camel@c-dwalke-linux.qualcomm.com>	 <4CFFE965.30906@codeaurora.org> <1291839992.12568.31.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1291839992.12568.31.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 12:26 PM, Daniel Walker wrote:
>
> The last time I thought you said there was no size change ? My tests
> showed a decrease ..

Oh, right. There was no size change when I moved __delay() into the
header in addition to the others.

>
> What compiler optimizations are you talking about 

See

Subject: Weirdo gcc 4.3.x behaviour
Message-ID: <20101121191148.GA12234@n2100.arm.linux.org.uk>

and

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29950

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

