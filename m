Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1JCNFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:05:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:59156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab1JCNF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:05:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,479,1312182000"; 
   d="scan'208";a="69750275"
Date: Mon, 3 Oct 2011 16:04:09 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Message-ID: <20111003130409.GA2487@xps8300>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1317036092-3000-15-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317036092-3000-15-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Sep 26, 2011 at 02:21:27PM +0300, Heikki Krogerus wrote:
> Use struct usb_otg members with OTG specific functions instead
> of usb_phy members.
> 
> Includes fixes from Sascha Hauer.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Have you had time to check it these work?

-- 
heikki
