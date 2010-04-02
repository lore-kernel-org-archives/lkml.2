Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab0DBCxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 22:53:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40100
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759162Ab0DBCxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 22:53:51 -0400
Date: Thu, 01 Apr 2010 19:53:52 -0700 (PDT)
Message-Id: <20100401.195352.258678503.davem@davemloft.net>
To: s.hauer@pengutronix.de
Cc: bryan.wu@canonical.com, gerg@uclinux.org, amit.kucheria@canonical.com,
       w.sang@pengutronix.de, kernel-team@lists.ubuntu.com,
       netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
 detection (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100331122604.GV2241@pengutronix.de>
References: <1270037444-8470-1-git-send-email-bryan.wu@canonical.com>
	<20100331122604.GV2241@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Wed, 31 Mar 2010 14:26:04 +0200

> On Wed, Mar 31, 2010 at 08:10:44PM +0800, Bryan Wu wrote:
>> BugLink: http://bugs.launchpad.net/bugs/457878
>> 
>> v2:
>>  - remove duplicated phy_speed caculation
>>  - fix the phy_speed caculation according to the DataSheet
>> 
>> v1:
>>  - removed old MII phy control code
>>  - add phylib supporting
>>  - add ethtool interface to make user space NetworkManager works
>> 
>> Tested on Freescale i.MX51 Babbage board.
>> 
>> This patch is based on a patch from Frederic Rodo <fred.rodo@gmail.com>
>> 
>> Cc: Frederic Rodo <fred.rodo@gmail.com>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied to net-next-2.6, thanks.
