Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0GXIX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:23:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38862 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0GXIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:23:55 -0400
Date: Sat, 24 Jul 2010 09:23:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
Message-ID: <20100724082334.GB15571@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org> <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 11:58:02AM -0700, Jeff Ohlstein wrote:
> From: Steve Muckle <smuckle@codeaurora.org>
> 
> ScorpionMP does not have the SMP/nAMP mode and TLB ops
> broadcasting bits in the ACTLR.

Please provide a separate instance of __v7_proc_info for your processor
and direct it to jump into the __v7_setup code after this setup instead.
