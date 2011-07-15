Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1GOU76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:59:58 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:39855 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab1GOU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:59:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADqpIE5tg2Sw/2dsb2JhbABTp254iHoCwmEOhiwEozs
Date: Fri, 15 Jul 2011 22:59:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/3] SP805 updates for Versatile Express
Message-ID: <20110715205954.GR3834@infomag.iguana.be>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> Here are some updates to get the SP805 watchdog working on the ARM
> Versatile Express.  The first two patches fix observed issues; the
> third fixes a potential (but not observed) issue with asynchronous
> posted writes.
> 
> All three patches are independent and should be applicable in any
> order, with some fuzz on the third.

looks good at first glance.

Russel: what's your opinion?

Kind regards,
Wim.

