Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1HVN6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:58:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:21498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1HVN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:58:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40603654"
Date: Mon, 22 Aug 2011 16:00:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Add more checks for WM8994 being active during
 suspend
Message-ID: <20110822140054.GS4607@sortiz-mobl>
References: <1313213868-14824-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313213868-14824-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Aug 13, 2011 at 02:37:48PM +0900, Mark Brown wrote:
> Enhancements to the WM8994 audio driver and new features on more modern
> devices in the series mean that we can no longer rely on VMID being active
> as an indication that the device is active. Add further checks for digital
> paths and microphone detection.
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
