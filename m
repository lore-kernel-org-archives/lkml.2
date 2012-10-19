Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2JSG0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:26:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65236 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab2JSG0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:26:51 -0400
Date: Fri, 19 Oct 2012 08:26:41 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ptp_pch: release chip->mem_base and chip->regs on error
Message-ID: <20121019062641.GC2983@netboy.at.omicron.at>
References: <1350553732-17204-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350553732-17204-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 05:48:52PM +0800, Yuanhan Liu wrote:
> Fix smatch warnings catched by Fengguang's 0-DAY system:
> + drivers/ptp/ptp_pch.c:641 pch_probe() warn: 'chip->mem_base' was not released on error
> + drivers/ptp/ptp_pch.c:641 pch_probe() warn: 'chip->regs' was not released on error
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
