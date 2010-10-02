Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0JBD3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:29:21 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50076 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0JBD3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:29:20 -0400
Date: Fri, 1 Oct 2010 20:28:40 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: lm-sensors@lm-sensors.org, JBeulich@novell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [2/2] hwmon: cleanup some hotplug related macro definition
Message-ID: <20101002032840.GA26052@ericsson.com>
References: <1285480800-14558-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285480800-14558-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 06:00:00AM -0000, Chen Gong wrote:
> CONFIG_HOTPLUG_CPU is used too much in some drivers.
> This patch clean them up and add some proper __cpuinit definitons.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
Hi,

this patch fails to compile if SMP is undefined. For this reason, I have removed
it from the list of patches applied for -next.

Please re-submit a corrected version.

Thanks,
Guenter
