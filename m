Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1JYVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:06:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1JYVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:06:23 -0400
Date: Tue, 25 Oct 2011 22:06:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] msm: boards: Fix fallout from removal of
	machine_desc in fixup
Message-ID: <20111025210610.GA26579@n2100.arm.linux.org.uk>
References: <1319560519-18899-1-git-send-email-sboyd@codeaurora.org> <20111025205053.GA15649@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025205053.GA15649@huya.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:50:53PM -0700, David Brown wrote:
> On Tue, Oct 25, 2011 at 09:35:19AM -0700, Stephen Boyd wrote:
> > After 0744a3ee (ARM: platform fixups: remove mdesc argument to
> > fixup function, 2010-12-20) the fixup functions introduced in
> > 9e775ad (ARM: 7012/1: Set proper TEXT_OFFSET for newer MSMs,
> > 2011-08-12) cause warnings like:
> > 
> > arch/arm/mach-msm/board-msm8x60.c:85: warning: initialization
> > from incompatible pointer type
> > 
> > Fix them by removing the machine_desc argument from the fixup
> > functions.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Yes, these got missed among the merges.
> 
> Acked-by: David Brown <davidb@codeaurora.org>
> 
> Russell, would you prefer this to go through your tracker, or for me
> to push this to Arnd?

Either is fine.
