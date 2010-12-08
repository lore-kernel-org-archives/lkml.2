Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0LHVIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:08:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0LHVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:08:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6191"; a="66031984"
Subject: Re: [PATCHv3 2/4] ARM: Allow machines to override __delay()
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Arve Hj?nnev?g <arve@android.com>
In-Reply-To: <4CFFEB00.5090807@codeaurora.org>
References: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>
	 <1291783128-27520-3-git-send-email-sboyd@codeaurora.org>
	 <1291836162.12568.17.camel@c-dwalke-linux.qualcomm.com>
	 <4CFFE965.30906@codeaurora.org>
	 <1291839992.12568.31.camel@c-dwalke-linux.qualcomm.com>
	 <4CFFEB00.5090807@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 13:07:59 -0800
Message-ID: <1291842479.12568.39.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 12:30 -0800, Stephen Boyd wrote:
> On 12/08/2010 12:26 PM, Daniel Walker wrote:
> >
> > The last time I thought you said there was no size change ? My tests
> > showed a decrease ..
> 
> Oh, right. There was no size change when I moved __delay() into the
> header in addition to the others.

So is there a problem with doing the inlining then ? If you get the same
size kernel, then that seems like a lateral move in your case.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

