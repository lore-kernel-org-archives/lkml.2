Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2DWQTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:19:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab2DWQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:19:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6690"; a="181848176"
Date: Mon, 23 Apr 2012 09:19:41 -0700
From: David Brown <davidb@codeaurora.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/2] video: msm: Fix section mismatches in mddi.c
Message-ID: <20120423161941.GA26903@codeaurora.org>
References: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
 <4F94F3D7.5030904@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F94F3D7.5030904@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 06:16:55AM +0000, Florian Tobias Schandinat wrote:
> On 04/12/2012 06:45 PM, David Brown wrote:
> > The change
> >     commit 461cbe77d0a4f887c33a3a95ea68a7daf23b4302
> >     Author: Gregory Bean <gbean@codeaurora.org>
> >     Date:   Wed Jul 28 10:22:13 2010 -0700
> > 
> >         video: msm: Fix section mismatch in mddi.c.
> > 
> > fixes a section mismatch between the board file and the driver's probe
> > function, however, it misses the additional mismatches between the
> > probe function and some routines it calls.  Fix these up as well.
> > 
> > Signed-off-by: David Brown <davidb@codeaurora.org>
> 
> Applied.

Hmm.  I guess it is somewhat my fault, since I sent the message To
both myself and you.  I've already applied this to the MSM tree, and I
believe it has been merged into Linus' tree.  I don't think it'll be
an issue, since git merge will handle the duplicate patch fine.

Next time, I'll try to be clearer about which tree I'm thinking for a
patch to go through.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
