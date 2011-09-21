Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1IURuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:50:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1IURuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:50:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6476"; a="120441479"
Date: Wed, 21 Sep 2011 12:50:09 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Richard Kuo <rkuo@codeaurora.org>,
        linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Message-ID: <20110921175009.GA3703@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <201109101229.58445.pedro@codesourcery.com>
 <20110919152505.GB6830@codeaurora.org>
 <201109211715.20795.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109211715.20795.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:15:20PM +0100, Pedro Alves wrote:
> > On Sat, Sep 10, 2011 at 12:29:57PM +0100, Pedro Alves wrote:
> > > Yes, the x86/x86-64 ports or gdb and gdbserver are already
> > > using GET/SETREGSET even.

Thanks; after a bit of initial confusion, I've gotten gdb to
work with this, so I'm happy. 

> I wish there was an equivalent of PTRACE_GETREGSET for siginfo...

How? Why?

-- Linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
