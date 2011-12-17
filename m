Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1LQRQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 12:16:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1LQRQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 12:16:33 -0500
Date: Sat, 17 Dec 2011 17:15:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Fix cross compilation broken by failing size
	command
Message-ID: <20111217171545.GP14542@n2100.arm.linux.org.uk>
References: <20111214215815.GP32251@atomide.com> <1324032146-723-1-git-send-email-jkrzyszt@tis.icnet.pl> <20111217105737.GO14542@n2100.arm.linux.org.uk> <201112171401.30635.jkrzyszt@tis.icnet.pl> <alpine.LFD.2.02.1112171109210.2907@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112171109210.2907@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 11:38:34AM -0500, Nicolas Pitre wrote:
> Given that the build works for the vast majority of people now, there is 
> a risk that applying your first patch might break the build for more 
> people (currently only one known) than the number of people for whom 
> this is an improvement (currently only one known).
> 
> I suggested a simple fix for Russell's installation already:
> 
> 	ln -s size arm-linux-size

One which I've refused to do until I've investigated _why_ I don't have
this command.  And I've now done that (having waited the half-hour for
the fsck of the old machine to complete.)  It appears that several of
the binutils commands weren't transferred to the new machine from the
old machine.

That's now fixed - and it suggests that there isn't a version of
binutils which missed out on this command, so I think we can go with
the original patch.
