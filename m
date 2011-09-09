Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab1IIVSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:18:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767Ab1IIVST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:18:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6464"; a="117203664"
Date: Fri, 9 Sep 2011 16:18:08 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Message-ID: <20110909211808.GA3150@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <20110909010916.525482401@codeaurora.org>
 <CACM3HyGvJQABO3Hi6e+yH+Xoi+S+fctGrH3w4Jm7=zqtnPTXTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACM3HyGvJQABO3Hi6e+yH+Xoi+S+fctGrH3w4Jm7=zqtnPTXTQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:15:20PM +0200, Jonas Bonn wrote:
> 
> That said, I don't think gdbserver has been updated to use
> GETREGSET/SETREGSET.  This is a bit like the uClibc/glibc issue,

Some dumb questions then: I notice that a few arches declare
struct user_regs_struct in glibc, most of the others in the
kernel.  If I were to make pt_regs completely kernel-private,
then I really do need to have struct user_regs_struct declared
the kernel headers, right? 

Putting a printk into case PTRACE_POKEUSR seemed to show that
gdb was using this (and was somehow mis-numbering the registers
... sigh.) Are you saying that the default should handle this?

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
