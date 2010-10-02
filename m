Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0JBD0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:26:12 -0400
Received: from imr3.ericy.com ([198.24.6.13]:57155 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0JBD0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:26:11 -0400
Date: Fri, 1 Oct 2010 20:26:03 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: lm-sensors@lm-sensors.org, JBeulich@novell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [1/2] hwmon: uniform the init style of pkgtemp
Message-ID: <20101002032603.GA25998@ericsson.com>
References: <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 05:59:59AM -0000, Chen Gong wrote:
> pkgtemp is derived from coretemp, so some reasonable
> logics should be applied onto pkgtemp, too. Such as
> the init logic here.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
Hi,

this patch, when applied with CONFIG_HOTPLUG_CPU undefined, causes a compile failure
because it tries to access pkgtemp_cpu_notifier which is not defined in this case.
 
For that reason, I have removed the patch from the list of applied patches for -next.
Please re-submit a version which compiles for all combinations of HOTPLUG_CPU and SMP
defined/undefined.

Thanks,
Guenter
