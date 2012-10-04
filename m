Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2JDUjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:39:14 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:41100 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2JDUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:39:13 -0400
Date: Thu, 4 Oct 2012 16:39:43 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/6] ARM: davinci: da850: changed SRAM allocator to
 shared ram.
Message-ID: <20121004203943.GM11149@beef>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <1349276133-26408-4-git-send-email-mporter@ti.com>
 <506D79A3.4020506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D79A3.4020506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 05:27:23PM +0530, Sekhar Nori wrote:
> Matt,
> 
> On 10/3/2012 8:25 PM, Matt Porter wrote:
> > From: Subhasish Ghosh <subhasish@mistralsolutions.com>
> > 
> > This patch modifies the sram allocator to allocate memory
> > from the DA8XX shared RAM.
> > 
> > Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> > [rebased onto consolidated SRAM patches]
> > Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> > [rebased to mainline as consolidated SRAM patches were dropped]
> > Signed-off-by: Matt Porter <mporter@ti.com>
> 
> Were you able to test PM with this change or you need my help?

I verified suspend/resume is working fine with this change on
AM180x EVM. Will note this all in v4.

-Matt
