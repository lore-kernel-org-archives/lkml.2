Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2ERFgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:36:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2ERFgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:36:03 -0400
Date: Fri, 18 May 2012 01:35:46 -0400 (EDT)
Message-Id: <20120518.013546.737313304742968032.davem@davemloft.net>
To: mjg59@srcf.ucam.org
Cc: shemminger@vyatta.com, paul.gortmaker@windriver.com, arnd@arndb.de,
        john.calixto@modsystems.com, xemul@parallels.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] econet: remove ancient bug ridden protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120518042301.GA723@srcf.ucam.org>
References: <20120517205951.462d336f@nehalam.linuxnetplumber.net>
	<20120518042301.GA723@srcf.ucam.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 22:35:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Fri, 18 May 2012 05:23:01 +0100

> On Thu, May 17, 2012 at 08:59:51PM -0700, Stephen Hemminger wrote:
> 
>> The ancient Econet protocol should go. Most of the bug fixes in recent
>> years have been fixing security vulnerabilities. The hardware hasn't
>> been made since 1981, it is only interesting as an archeological curiosity.
> 
> Pedantry - the hardware was introduced in 1981, it was still being made 
> into at least the 90s. Still probably time for it to die, though.

Patch applied with this pedantic adjustment :-)
