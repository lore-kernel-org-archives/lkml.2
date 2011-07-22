Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1GVTCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:02:14 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:46258 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1GVTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:02:12 -0400
Date: Fri, 22 Jul 2011 15:01:50 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] SP805 updates for Versatile Express
Message-ID: <20110722190150.GA24621@elliptictech.com>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
 <20110715205954.GR3834@infomag.iguana.be>
 <20110718094409.GQ23270@n2100.arm.linux.org.uk>
 <20110719131508.GA30207@elliptictech.com>
 <20110722183146.GE31767@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722183146.GE31767@infomag.iguana.be>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-22 20:31 +0200, Wim Van Sebroeck wrote:
> Hi Nick, Russel,
> > Indeed, there are likely several other ways in which this driver can be
> > improved.  My goal was to get it working on our board first. :)
> 
> Feel free to continue improving the driver like Russel suggested. :-)

I'll see what I can do :)

> > So if this series is fine, I'll submit #1 (the V2M patch) to Russel's
> > patch tracker.  I suppose #2 and #3 should go through the watchdog tree?
> 
> I added patch 2 and 3 to linux-2.6-watchdog-next. You can send #1 to 
> Russel's patch tracker.

OK, great.  I sent #1 to Russell's patch tracker a couple days ago.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
