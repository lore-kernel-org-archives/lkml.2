Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1AZWlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:41:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1AZWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:41:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71888053"
From: David Brown <davidb@codeaurora.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
In-Reply-To: <AANLkTi=UBfBp-VOQ=n_a4sjA9v_dhcv-rXcXiE6zrf23@mail.gmail.com>
	(Dima Zavin's message of "Wed, 26 Jan 2011 14:12:59 -0800")
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-3-git-send-email-davidb@codeaurora.org>
	<1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com>
	<8yaei81kjlc.fsf@huya.qualcomm.com>
	<AANLkTi=UBfBp-VOQ=n_a4sjA9v_dhcv-rXcXiE6zrf23@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110126:linux-kernel@vger.kernel.org::MyjAHgRwfouFn/zn:0000000000000000000000000000000000J1T
X-Hashcash: 1:20:110126:dwalker@codeaurora.org::pf4HwhvKyT/cE0cP:0000000000000000000000000000000000000001KJ/
X-Hashcash: 1:20:110126:linux-arm-msm@vger.kernel.org::+r8tr5Q0isfgde0H:000000000000000000000000000000002SbY
X-Hashcash: 1:20:110126:dmitriyz@google.com::r+ovYGvco6Ib8rAT:0000000000000000000000000000000000000000006CDV
X-Hashcash: 1:20:110126:linux-arm-kernel@lists.infradead.org::dLEYICJwLbiwxHR1:00000000000000000000000009otM
Date: Wed, 26 Jan 2011 14:41:07 -0800
Message-ID: <8ya7hdr70fw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26 2011, Dima Zavin wrote:

> On Mon, Jan 24, 2011 at 2:44 PM, David Brown <davidb@codeaurora.org> wrote:

> To be honest I don't understand why you would want to do this at
> runtime. You cannot select multiple SoCs in the kernel build anyway,
> nor would you want to. Trying to have same kernel to boot on ARM v6
> and ARM v7 would already be freaky enough. On top of that mixing 7201a
> with all the baggage that it comes with 8x60 just wouldn't make sense.
> These architectures are so different that it I can't see that ever
> being useful. When would you ever envision building for multiple of
> these SoCs at the same time?

People (especially distributions) want to be able to build one arm
kernel rather than multiple ones.  The issues about CPU detection and
base addresses are being worked on now.

Other targets, especially omap, are already way ahead of MSM in this
area.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
