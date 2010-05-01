Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0EAKPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 06:15:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33005 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0EAKPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 06:15:11 -0400
Date: Sat, 1 May 2010 11:14:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arm/mach-msm: Add CONFIG conditional for board-trout
Message-ID: <20100501101442.GH12172@n2100.arm.linux.org.uk>
References: <201004290241.23068.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004290241.23068.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 02:41:22AM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch adds a conditional for CONFIG_MSM_DEBUG_UART to prevent a
> build failure[1], this is done the same way as for every board in mach-msm.
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2448102/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Who's going to deal with getting this patch upstream?
