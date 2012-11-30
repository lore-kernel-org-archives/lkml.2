Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767735Ab2K3UA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:00:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46698 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616Ab2K3UAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:00:54 -0500
Date: Fri, 30 Nov 2012 15:00:48 -0500 (EST)
Message-Id: <20121130.150048.112475787724653030.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: jkosina@suse.cz, pt@netconsequence.de, otavio@ossystems.com.br,
        javier@dowhile0.org, chohnstaedt@innominate.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: RFC: Workaround for problems with lan8710 phy
 auto MDI-X
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354302880.2640.1.camel@bwh-desktop.uk.solarflarecom.com>
References: <alpine.LNX.2.00.1211301622110.25639@pobox.suse.cz>
	<20121130.122302.1825816242500143123.davem@davemloft.net>
	<1354302880.2640.1.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 30 Nov 2012 19:14:40 +0000

> On Fri, 2012-11-30 at 12:23 -0500, David Miller wrote:
>> From: Jiri Kosina <jkosina@suse.cz>
>> Date: Fri, 30 Nov 2012 16:23:30 +0100 (CET)
>> 
>> > Of course it'd be far better if faulty hardware can be autodetected in 
>> > runtime.
>> 
>> That is how this must be handled.
> 
> Well, we also have the recent extension to ETHTOOL_SSET for forcing
> MDI-X on or off.  If it's not possible to detect the faulty hardware
> then the driver can implement this.

Agreed.
