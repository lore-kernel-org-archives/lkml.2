Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1FTO7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:59:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:42994 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1FTO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15933562"
Date: Mon, 20 Jun 2011 16:59:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver
 initialization
Message-ID: <20110620145941.GQ22420@sortiz-mobl>
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
 <20110620132626.GJ22420@sortiz-mobl>
 <20110620132851.GJ14262@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620132851.GJ14262@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Mon, Jun 20, 2011 at 04:28:52PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jun 20, 2011 at 03:26:26PM +0200, Samuel Ortiz wrote:
> > On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
> > > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> > > 
> > > Oops are produced during initialization of ehci and ohci
> > > drivers. This is because the run time pm apis are used by
> > > the driver but the corresponding hwmod structures and
> > > initialization is not merged. 
> > You mean they're currently checked in a different tree ? Is that a
> > public one?
> 
> it was supposed to go via linux-omap tree but the patches got lost in
> the limbo :-(
Then shouldn't those patches be the ones to be sent to Linus as a fix for 3.0 ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
