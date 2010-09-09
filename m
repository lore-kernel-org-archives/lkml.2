Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0IIGHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 02:07:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab0IIGH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 02:07:29 -0400
Date: Wed, 08 Sep 2010 23:07:47 -0700 (PDT)
Message-Id: <20100908.230747.71591658.davem@davemloft.net>
To: greg@kroah.com
Cc: linux@rainbow-software.org, simon@fire.lp0.eu,
        dbrownell@users.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cxacru: ignore cx82310_eth devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100909033557.GA3723@kroah.com>
References: <20100908.131227.28827971.davem@davemloft.net>
	<201009082252.15865.linux@rainbow-software.org>
	<20100909033557.GA3723@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 8 Sep 2010 20:35:57 -0700

> On Wed, Sep 08, 2010 at 10:52:12PM +0200, Ondrej Zary wrote:
>> Ignore ADSL routers, which can have the same vendor and product IDs
>> as ADSL modems but should be handled by the cx82310_eth driver.
>> 
>> This intentionally ignores device IDs that aren't currently handled
>> by cx82310_eth. There may be other device IDs that perhaps shouldn't
>> be claimed by cxacru.
> 
> Looks good, thanks, I'll go queue it up.

Greg, see my reply, I already tossed this into net-next-2.6
