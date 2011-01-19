Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1ASTwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:52:05 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20174 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1ASTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:52:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70906936"
From: David Brown <davidb@codeaurora.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
In-Reply-To: <20110119173739.GE3341@pulham.picochip.com> (Jamie Iles's message
	of "Wed, 19 Jan 2011 17:37:39 +0000")
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org>
	<20110119082534.GA9569@gallagher> <8yaaaiwsstw.fsf@huya.qualcomm.com>
	<20110119173739.GE3341@pulham.picochip.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110119:linux-arm-msm@vger.kernel.org::Zwum6LJJRkpl5Pgc:000000000000000000000000000000000hbh
X-Hashcash: 1:20:110119:stepanm@codeaurora.org::NNQJj2Tfgqmetv+7:0000000000000000000000000000000000000001msD
X-Hashcash: 1:20:110119:rlove@google.com::T5nTPg5MymBvqcNN:00qJz
X-Hashcash: 1:20:110119:linux-arm-kernel@lists.infradead.org::DKdPhxUCMrgz7nh9:00000000000000000000000002iwt
X-Hashcash: 1:20:110119:jamie@jamieiles.com::YIKWDujxQ258ieov:0000000000000000000000000000000000000000007t20
X-Hashcash: 1:20:110119:linux-kernel@vger.kernel.org::dioTsCYWRKA7mS9P:000000000000000000000000000000000DVBS
Date: Wed, 19 Jan 2011 11:52:02 -0800
Message-ID: <8ya7he0r7rx.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19 2011, Jamie Iles wrote:

> On Wed, Jan 19, 2011 at 09:31:55AM -0800, David Brown wrote:
>> I'm not sure what would be a better name for the flag, though.  The
>> block is called UARTDM.
>
> Ok, it was mainly out of curiosity.  I guess it could be 'use_dma' or 
> perhaps a comment to explain what DM is but my curiosity is now 
> satisfied ;-)

I think use_dma would probably be even more confusing, since it isn't
using dma.

It's a flag indicating if the device has the capability of doing dma.
It's really a block version indicator, except that the blocks weren't
given different versions, but instead given a name based on the DMA.

I wonder if is_dma_capable would be better.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
