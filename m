Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1AUC05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 21:26:57 -0500
Received: from imr3.ericy.com ([198.24.6.13]:35442 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1AUC04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 21:26:56 -0500
Date: Thu, 20 Jan 2011 18:26:11 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fenghua Yu <fenghua.yu@intel.com>
CC: "R, Durgadoss" <durgadoss.r@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>
Subject: Re: patch[1/1]:hwmon:Adding_Threshold_support_to_coretemp
Message-ID: <20110121022611.GC9496@ericsson.com>
References: <D6D887BA8C9DFF48B5233887EF046541094482ED6A@bgsmsx502.gar.corp.intel.com>
 <20110120221704.GA26954@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110120221704.GA26954@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 05:17:05PM -0500, Fenghua Yu wrote:
[ ... ]
> This patch has compilation error:
> ERROR: "platform_thermal_notify" [drivers/hwmon/coretemp.ko] undefined!
> 
> The reason is commit 9e76a97efd31a08cb19d0ba12013b8fb4ad3e474 patch for
> therm_throt.c in upstream doesn't export the symbol platform_thermal_notify.
> 
> The following patch should fix the issue. Apply it before compiling your patch.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

You are hiding your patch in a reply to another patch. Plus, your patch needs to go
into a different subsystem. Hope the x86 maintainers catch it.

Guenter
