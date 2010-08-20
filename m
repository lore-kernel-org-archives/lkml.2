Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0HTVwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:52:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:11977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0HTVwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="598738877"
Date: Fri, 20 Aug 2010 23:52:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: Align ab8500 with the abx500 interface
Message-ID: <20100820215206.GI3650@sortiz-mobl>
References: <1282037077-29255-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282037077-29255-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Tue, Aug 17, 2010 at 11:24:37AM +0200, Mattias Wallin wrote:
> This patch makes the ab8500 mixed signal chip expose the same
> interface for register access as the ab3100, ab3550 and ab5500 chip.
> The ab8500_read() and ab8500_write() is removed and replaced with
> abx500_get_register_interruptible() and
> abx500_set_register_interruptible().
Thanks for the patch, but I'd prefer to see it split into 3 separate ones, for
mfd, rtc and regulator. And then have the relevant maintaines cc'ed with those
patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
