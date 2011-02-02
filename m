Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1BBWqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:46:43 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41281 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BBWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:46:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="72762260"
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-Reply-To: <alpine.LFD.2.00.1102021557530.8212@xanadu.home> (Nicolas Pitre's
	message of "Wed, 02 Feb 2011 16:47:12 -0500 (EST)")
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
	<8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
	<20110202200030.GA26104@flint.arm.linux.org.uk>
	<20110202203252.GD28479@kroah.com>
	<20110202204453.GB26104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1102021557530.8212@xanadu.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110202:stepanm@codeaurora.org::ii9v4A/sN2LKomMb:0000000000000000000000000000000000000000G+I
X-Hashcash: 1:20:110202:linux-kernel@vger.kernel.org::Juc5IP4G/U2wPNO7:0000000000000000000000000000000000R09
X-Hashcash: 1:20:110202:rmk@arm.linux.org.uk::5fzLrc1Wm4i+MYB7:000000000000000000000000000000000000000001cMa
X-Hashcash: 1:20:110202:greg@kroah.com::q0DFkY1zeJRpRui3:00021SC
X-Hashcash: 1:20:110202:nico@fluxnic.net::oHN41XGhUKl+4fEJ:03MXv
X-Hashcash: 1:20:110202:sfr@canb.auug.org.au::YvXDr3pdbiChoNEL:0000000000000000000000000000000000000000044nv
X-Hashcash: 1:20:110202:linux-next@vger.kernel.org::JukE9eMEOvTiVkQh:00000000000000000000000000000000000Q5pt
Date: Wed, 02 Feb 2011 14:46:40 -0800
Message-ID: <8yar5bq5a27.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02 2011, Nicolas Pitre wrote:

> The actual problem here is that some people, notably the msm folks, are 
> bypassing the maintainer hierarchy and going straight to Linus for their 
> pull requests instead of asking RMK to pull.  We once debated this at 
> some point and it was agreed that completely independent SOC specific 
> code with no dependencies on the common ARM code _could_ go straight to 
> Linus directly if they crave for it.  But in this case:
>
> 1) the conflict is obviously simple
>
> 2) the conflict resolution is just as obvious
>
> 3) and Stephen is able and willing to carry this conflict resolution for 
>    the foreseeable future until this all gets merged in mainline.
>
> So... WTF is the actual problem here?

I hadn't really brought this up as a problem, but was mostly wondering
if it was ok to just have Stephen carry the conflict resolution until
the next merge window.  The rest of the comments came from Greg.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
