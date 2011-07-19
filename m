Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab1GSNPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:15:20 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:50742 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803Ab1GSNPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:15:18 -0400
Date: Tue, 19 Jul 2011 09:15:08 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] SP805 updates for Versatile Express
Message-ID: <20110719131508.GA30207@elliptictech.com>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
 <20110715205954.GR3834@infomag.iguana.be>
 <20110718094409.GQ23270@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718094409.GQ23270@n2100.arm.linux.org.uk>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-18 10:44 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 15, 2011 at 10:59:54PM +0200, Wim Van Sebroeck wrote:
> > looks good at first glance.
> > 
> > Russel: what's your opinion?
> 
> Win,
> 
> This series looks fine.  However, looking through the driver, there's
> a few oddities:

Indeed, there are likely several other ways in which this driver can be
improved.  My goal was to get it working on our board first. :)

So if this series is fine, I'll submit #1 (the V2M patch) to Russel's
patch tracker.  I suppose #2 and #3 should go through the watchdog tree?

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
