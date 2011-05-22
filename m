Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1EVTHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:07:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:3732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1EVTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:07:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,252,1304319600"; 
   d="scan'208";a="440932426"
Date: Sun, 22 May 2011 21:07:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [PATCH v1] omap: usbhs: Fixed the crash during rmmod of ehci
 and ohci
Message-ID: <20110522190718.GA18610@sortiz-mobl>
References: <1305536098-19871-1-git-send-email-keshava_mgowda@ti.com>
 <20110518105312.GG13908@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518105312.GG13908@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, May 18, 2011 at 01:53:15PM +0300, Felipe Balbi wrote:
> On Mon, May 16, 2011 at 02:24:58PM +0530, Keshava Munegowda wrote:
> > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> > 
> > The disabling of clocks and freeing GPIO are changed
> > to fix the occurrence of the crash of rmmod of ehci and ohci
> > drivers. The GPIOs should be freed after the spin locks are
> > unlocked.
> > 
> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> should this have:
> 
> Cc: stable@kernel.org ??
Patch applied, with stable cc'ed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
