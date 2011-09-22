Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1IVNc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:32:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58584 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1IVNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
Date: Thu, 22 Sep 2011 21:32:53 +0800
Message-ID: <CACVXFVOoHM14AqqH0CSpwNPef1QL+7MtgZOQZhYVSdgA=5KR4g@mail.gmail.com>
Subject: Re: [PATCH 0/5 v11] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: Ming Lei <tom.leiming@gmail.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, paul@pwsan.com,
        balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 22, 2011 at 7:37 PM, Keshava Munegowda
<keshava_mgowda@ti.com> wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
>
> These patches are re-based to Kevin's pm branch :
> git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git

Is kernel.org up now? :-)

thanks,
-- 
Ming Lei
