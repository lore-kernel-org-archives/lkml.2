Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1FNH6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:58:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:45075 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1FNH6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:58:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,363,1304319600"; 
   d="scan'208";a="15951719"
Date: Tue, 14 Jun 2011 09:58:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>
Subject: Re: [PATCH 1/2] input: pmic8xxx-keypad: Do not use mfd_get_data()
Message-ID: <20110614075804.GA2880@sortiz-mobl>
References: <20110608091341.GJ2880@sortiz-mobl>
 <20110611232146.GB3979@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110611232146.GB3979@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sat, Jun 11, 2011 at 04:21:46PM -0700, Dmitry Torokhov wrote:
> On Wed, Jun 08, 2011 at 11:13:41AM +0200, Samuel Ortiz wrote:
> > 
> > mfd_get_data() has been removed from the MFD API.
> > 
> > Cc: Anirudh Ghayal <aghayal@codeaurora.org>
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Samuel, do you want to push this and the other patch with my acks
> through your tree?
Yes, I'd like to do so. I'm hopefully going to be able to find time this week
to send an MFD fixes pull request to Linus, and those 2 will be part of it.
Thanks for the ACK.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
