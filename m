Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2BVXBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:01:17 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35630 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2BVXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:01:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/T54ARpkOV7l9pnn3rYlvR
Date: Wed, 22 Feb 2012 15:01:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] OMAP: 4430SDP: Correct fixed regulator device ID
Message-ID: <20120222230109.GQ18185@atomide.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
 <1328868316-24749-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328868316-24749-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120210 01:34]:
> The board has two fixed voltage regulator. Correct the
> device ID for the vbat, which used -1.
> Create defines for the fixed regulator IDs so when adding new
> regulators we know the next available ID to use for them.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>
