Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1BDUiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:38:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1BDUiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:38:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73239573"
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Daniel Walker <dwalker@codeaurora.org>, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-Reply-To: <alpine.LFD.2.00.1102041421310.12104@xanadu.home> (Nicolas
	Pitre's message of "Fri, 04 Feb 2011 14:40:04 -0500 (EST)")
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
	<8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
	<20110202200030.GA26104@flint.arm.linux.org.uk>
	<20110202203252.GD28479@kroah.com>
	<20110202204453.GB26104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1102021557530.8212@xanadu.home>
	<1296839855.4078.12.camel@m0nster>
	<alpine.LFD.2.00.1102041421310.12104@xanadu.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110204:linux-kernel@vger.kernel.org::g4a26bd56QvXhgq5:0000000000000000000000000000000000TLW
X-Hashcash: 1:20:110204:greg@kroah.com::qWs48Lcrk1PpZ9V7:00022pV
X-Hashcash: 1:20:110204:linux-arm-msm@vger.kernel.org::x4ZKvya8ncKo7CRn:000000000000000000000000000000000S4z
X-Hashcash: 1:20:110204:nico@fluxnic.net::eLzzyYNHjMf039u9:03VQP
X-Hashcash: 1:20:110204:dwalker@codeaurora.org::L7yN3lFbuUojcNEv:0000000000000000000000000000000000000002Snw
X-Hashcash: 1:20:110204:sfr@canb.auug.org.au::nlPtCXlcogPCIrOr:000000000000000000000000000000000000000004PJP
X-Hashcash: 1:20:110204:linux-next@vger.kernel.org::nUicLzsezQHZ0jnN:000000000000000000000000000000000003Opb
X-Hashcash: 1:20:110204:rmk@arm.linux.org.uk::dydVq3OOKmxIXrm/:000000000000000000000000000000000000000003ZHQ
X-Hashcash: 1:20:110204:stepanm@codeaurora.org::zxBln9x/Fb8PhIOe:0000000000000000000000000000000000000003Acz
Date: Fri, 04 Feb 2011 12:38:01 -0800
Message-ID: <8yawrlfzgba.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04 2011, Nicolas Pitre wrote:

> Maybe this would be nicer to Russell and others performing wide ranging 
> changes to the ARM code if the msm tree was more visible downstream, and 
> potentially help to avoid making a mountain out of a mole hill.

Currently, the msm tree is in linux-next, and the URL is in the
MAINTAINER's file.  The only want to make it more visible would be to
give frequent pull requests to RMK, which would create extra work for
him.  I think I just need to come up with the right balance of how often
to give the tree to RMK.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
