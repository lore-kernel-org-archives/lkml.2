Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0G1V6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:58:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0G1V6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:58:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49119769"
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20100724082334.GB15571@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
	 <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
	 <20100724082334.GB15571@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 14:58:00 -0700
Message-ID: <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-24 at 09:23 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 23, 2010 at 11:58:02AM -0700, Jeff Ohlstein wrote:
> > From: Steve Muckle <smuckle@codeaurora.org>
> > 
> > ScorpionMP does not have the SMP/nAMP mode and TLB ops
> > broadcasting bits in the ACTLR.
> 
> Please provide a separate instance of __v7_proc_info for your processor
> and direct it to jump into the __v7_setup code after this setup instead.


You mean add another label into __v7_setup along with a proc-msm.S to
jump over this code?

Daniel
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

