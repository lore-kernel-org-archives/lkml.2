Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1FTOoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:44:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:62234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1FTOoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:44:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="17299172"
Date: Mon, 20 Jun 2011 16:44:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] Add tunnelcreek watchdog to lpc_sch devices
Message-ID: <20110620144409.GN22420@sortiz-mobl>
References: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Thu, Jun 16, 2011 at 01:05:49PM +0200, Alexander Stein wrote:
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
I guess it's about time to implement a routine for the pci_read_config_dword()
-> convert to base_addr -> set resource pattern.
I applied your patch though, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
