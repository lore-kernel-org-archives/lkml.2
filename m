Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2BXEce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:32:34 -0500
Received: from linux-sh.org ([111.68.239.195]:47805 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab2BXEcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:32:32 -0500
Date: Fri, 24 Feb 2012 13:31:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-shmobile/board-ag5evm.c: included linux/dma-mapping.h twice
Message-ID: <20120224043145.GE9994@linux-sh.org>
References: <1329403598-304-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329403598-304-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:46:38PM +0100, Danny Kukawka wrote:
> arch/arm/mach-shmobile/board-ag5evm.c: included 'linux/dma-mapping.h'
> twice, remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks.
