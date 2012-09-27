Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2I0V6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:58:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58617 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0V6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:58:30 -0400
Date: Thu, 27 Sep 2012 17:58:28 -0400 (EDT)
Message-Id: <20120927.175828.1507389182330392541.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: christophe.leroy@c-s.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] lxt PHY: Support for the buggy LXT973 rev A2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120925074736.GB2169@netboy.at.omicron.at>
References: <20120924183035.GA2252@netboy.at.omicron.at>
	<50614DEE.9050400@c-s.fr>
	<20120925074736.GB2169@netboy.at.omicron.at>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Tue, 25 Sep 2012 09:47:36 +0200

> On Tue, Sep 25, 2012 at 08:23:42AM +0200, leroy christophe wrote:
>> 
>> A2 chip has phy_id 0x00137a10
>> A3 chip has phy_id 0x00137a11
> 
> Okay then, thanks.
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied to net-next, thanks.
