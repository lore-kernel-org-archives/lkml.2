Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1BDSCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:02:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1BDSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:02:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73013462"
From: David Brown <davidb@codeaurora.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-Reply-To: <20110204174244.GA7396@flint.arm.linux.org.uk> (Russell King's
	message of "Fri, 4 Feb 2011 17:42:44 +0000")
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
	<8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
	<20110202200030.GA26104@flint.arm.linux.org.uk>
	<20110202203252.GD28479@kroah.com>
	<20110202204453.GB26104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1102021557530.8212@xanadu.home>
	<1296839855.4078.12.camel@m0nster>
	<20110204174244.GA7396@flint.arm.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110204:dwalker@codeaurora.org::+l+lZYMBv7mT35rP:0000000000000000000000000000000000000000GgA
X-Hashcash: 1:20:110204:rmk@arm.linux.org.uk::IaJvpxOyt1pueGdz:000000000000000000000000000000000000000000Ab0
X-Hashcash: 1:20:110204:nico@fluxnic.net::VujCk3/jv1hP42ug:01A4i
X-Hashcash: 1:20:110204:greg@kroah.com::5gjVtnG5RfpP8FjF:0001iEj
X-Hashcash: 1:20:110204:linux-kernel@vger.kernel.org::AO6TuTdg43j/1Ytg:0000000000000000000000000000000001GOJ
X-Hashcash: 1:20:110204:linux-arm-msm@vger.kernel.org::m3vtNQc3+MwxttMY:000000000000000000000000000000001L74
X-Hashcash: 1:20:110204:linux-next@vger.kernel.org::tzS9akufEgZiPAux:000000000000000000000000000000000001hH9
X-Hashcash: 1:20:110204:sfr@canb.auug.org.au::B6nL+YaLha1i2l+Z:000000000000000000000000000000000000000004HtI
X-Hashcash: 1:20:110204:stepanm@codeaurora.org::U31mOmW1nlB+1FE7:0000000000000000000000000000000000000006jFZ
Date: Fri, 04 Feb 2011 10:02:19 -0800
Message-ID: <8yaei7n1xw4.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04 2011, Russell King wrote:

> I really don't care which - but I'll warn you that keeping changes
> hidden will result in a reduction of patch quality, and much much
> much less testing of those changes.  And I won't care at all when you
> complain that MSM's broken because of one of my patches.
>
> Exactly what would you prefer?

I'd like to get a little bit of an idea what you would prefer me to do.

I see two reasonable workflows:

  - I make a branch for the files that conflict with other changes in
    the ARM tree and submit pull requests to you (Russell) for these
    changes.  Other MSM-specific changes would be in another tree that
    goes to Linus.

  - I submit everything via pull requests to you.  This would probably
    result in one additional request to you, that contained the stuff
    that didn't conflict, since it would be nice to resolve the obvious
    conflicts earlier.

The later is more work for you, and less for Linus.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
