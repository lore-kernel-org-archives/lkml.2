Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab0DPSuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 14:50:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48410 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757722Ab0DPSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 14:49:59 -0400
Date: Sat, 17 Apr 2010 03:50:04 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix fencepost error in reg cache access check
Message-ID: <20100416185003.GB24707@opensource.wolfsonmicro.com>
References: <1271419209-21634-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271419209-21634-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:00:09PM +0300, Phil Carmody wrote:
> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> Accessing num_reg elements in the interval [reg .. reg+num_regs)
> is permitted if (reg+numregs <= array size), so barf when that
> excluded upper bound is > array size. The prior -1 would give
> access to one too many elements.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
