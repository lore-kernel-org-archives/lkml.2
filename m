Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1ISPZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:25:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28064 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1ISPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:25:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6473"; a="119621104"
Date: Mon, 19 Sep 2011 10:25:05 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Richard Kuo <rkuo@codeaurora.org>,
        linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Message-ID: <20110919152505.GB6830@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <20110909211808.GA3150@codeaurora.org>
 <CACM3HyH8P=u9pR0sa2besxsgDN5TUKg_7utLJTwL+hu8Wv48ow@mail.gmail.com>
 <201109101229.58445.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109101229.58445.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 12:29:57PM +0100, Pedro Alves wrote:
> On Saturday 10 September 2011 07:42:26, Jonas Bonn wrote:
> 
> > I'm really not an expert on GDB, but I believe it can use either the
> > PEEK/POKE functions to access regs, or it can use GET/SETREGS; it's an
> > architecture-dependent configuration.  I think the second variant can
> > be easily modified to become GET/SETREGSET instead, and the PEEK/POKE
> > variant wouldn't be needed at all.
> 
> Yes, the x86/x86-64 ports or gdb and gdbserver are already
> using GET/SETREGSET even.

Reading the code, it seemed to only fetch "extended state" in
this way, and not all of the registers.  Am I mistaken?

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
