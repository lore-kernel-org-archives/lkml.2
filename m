Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1I2KuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:50:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59516 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1I2KuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:50:23 -0400
Date: Thu, 29 Sep 2011 11:49:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
	choice
Message-ID: <20110929104954.GI23944@n2100.arm.linux.org.uk>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org> <1316568208-4518-2-git-send-email-sboyd@codeaurora.org> <4E83D25C.6020306@codeaurora.org> <20110929092102.GB25061@e102144-lin.cambridge.arm.com> <20110929094243.GC25061@e102144-lin.cambridge.arm.com> <20110929094602.GH23944@n2100.arm.linux.org.uk> <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 11:39:39AM +0100, Will Deacon wrote:
> Ok. Rather than 'default' (which people will probably select in preference
> to choosing the correct UART) how about something like below? I can split
> this into two patches if you prefer.

Yup, that's what I meant.
