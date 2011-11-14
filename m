Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1KNAP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:15:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:52704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KNAP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:15:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="74847637"
Date: Mon, 14 Nov 2011 01:20:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Disable more pulls on WM8994
Message-ID: <20111114002012.GI22218@sortiz-mobl>
References: <1320327674-23116-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320327674-23116-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Nov 03, 2011 at 01:41:14PM +0000, Mark Brown wrote:
> Disable more pulls by default on WM8994 for a small current saving. Since
> some designs do leave SPKMODE floating provide platform data to allow that
> to be left enabled.
All right, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
