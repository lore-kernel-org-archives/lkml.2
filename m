Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HSRId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:08:33 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33983 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0HSRIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:08:31 -0400
Date: Thu, 19 Aug 2010 10:07:17 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>,
        H Peter Anvin <hpa@zytor.com>, Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] drivers/hwmon/coretemp: Fix incorrect
 hot-removed CPU's core sensor issue
Message-ID: <20100819170717.GA4312@ericsson.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 06:53:45PM -0400, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> In current coretemp driver, when a CPU in dev_list is hot-removed, although its
> HT sibling is still running, its core sensor is gone and not available to user
> level application any more.
> 
> When a CPU is hot-removed, its core sensor should be still available to upper
> level application as long as the hot-removed CPU's HT sibling is still running.
> A core sensor is invisible to user level only when all of siblings in a core are
> hot-removed.
>
Isn't that just a short term (ie a couple of ms or even us) race condition
until the sibling is removed as well ? If so, why bother ?

Thanks,
Guenter

