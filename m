Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1I3TBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:01:54 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37179 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab1I3TBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:01:52 -0400
Date: Fri, 30 Sep 2011 13:01:51 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 0/5 v12] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
In-Reply-To: <1317306247-1103-1-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1109301259570.12185@utopia.booyaka.com>
References: <1317306247-1103-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Keshava,

by the way, when you repost these, can you split this into two series -- 
one for the arch/arm/*omap* changes, and the other for changes that should 
go in through the MFD tree?  Then just note in the second series that it 
has a dependency on the first.  That will make it easier to merge these 
patches, and should cut down on the number of cc's that are necessary for 
most of these patches.


thanks

- Paul
