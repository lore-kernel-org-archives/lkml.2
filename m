Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1GVSbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:31:49 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:45969 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1GVSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:31:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOLAKU5tgwKe/2dsb2JhbABTp0Z4iHwCunoOhVJfBKNP
Date: Fri, 22 Jul 2011 20:31:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] SP805 updates for Versatile Express
Message-ID: <20110722183146.GE31767@infomag.iguana.be>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com> <20110715205954.GR3834@infomag.iguana.be> <20110718094409.GQ23270@n2100.arm.linux.org.uk> <20110719131508.GA30207@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719131508.GA30207@elliptictech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick, Russel,

> > > looks good at first glance.
> > > 
> > > Russel: what's your opinion?
> > 
> > Win,
> > 
> > This series looks fine.  However, looking through the driver, there's
> > a few oddities:
> 
> Indeed, there are likely several other ways in which this driver can be
> improved.  My goal was to get it working on our board first. :)

Feel free to continue improving the driver like Russel suggested. :-)

> So if this series is fine, I'll submit #1 (the V2M patch) to Russel's
> patch tracker.  I suppose #2 and #3 should go through the watchdog tree?

I added patch 2 and 3 to linux-2.6-watchdog-next. You can send #1 to 
Russel's patch tracker.

Kind regards,
Wim.

