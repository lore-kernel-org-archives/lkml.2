Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2DDWNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:13:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2DDWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:13:23 -0400
Date: Wed, 04 Apr 2012 18:09:54 -0400 (EDT)
Message-Id: <20120404.180954.2161890302149782420.davem@davemloft.net>
To: buytenh@wantstofly.org
Cc: jeffrey.t.kirsher@intel.com, robherring2@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, nico@fluxnic.net, arnd@arndb.de,
        olof@lixom.net, rob.herring@calxeda.com
Subject: Re: [PATCH 2/5] net: remove ixp2000 ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404122540.GA28523@wantstofly.org>
References: <1333503243-7702-2-git-send-email-robherring2@gmail.com>
	<1333534857.3046.33.camel@jtkirshe-mobl>
	<20120404122540.GA28523@wantstofly.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 15:09:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>
Date: Wed, 4 Apr 2012 14:25:40 +0200

> On Wed, Apr 04, 2012 at 03:20:57AM -0700, Jeff Kirsher wrote:
> 
>> > From: Rob Herring <rob.herring@calxeda.com>
>> > 
>> > The platform is removed, so there are no users of this driver.
>> > 
>> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> > Cc: Bruce Allan <bruce.w.allan@intel.com>
>> > Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
>> > Cc: Don Skidmore <donald.c.skidmore@intel.com>
>> > Cc: Greg Rose <gregory.v.rose@intel.com>
>> > Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>> > Cc: Alex Duyck <alexander.h.duyck@intel.com>
>> > Cc: John Ronciak <john.ronciak@intel.com>
>> > Cc: netdev@vger.kernel.org
> 
> Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Applied to net-next, thanks.
