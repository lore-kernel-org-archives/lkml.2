Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0JHMMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:12:25 -0400
Received: from imr3.ericy.com ([198.24.6.13]:32844 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0JHMMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:12:24 -0400
Date: Fri, 8 Oct 2010 05:11:45 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] hwmon: cleanup some hotplug related macro
 definition
Message-ID: <20101008121145.GB24789@ericsson.com>
References: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
 <1286517216-15640-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286517216-15640-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 01:53:36AM -0400, Chen Gong wrote:
> CONFIG_HOTPLUG_CPU is used too much in some drivers.
> This patch clean them up and add some proper __cpuinit definitons.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Please rebase this patch to 
git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-next 

Some of the changes are already applied through other patches.

Thanks,
Guenter
