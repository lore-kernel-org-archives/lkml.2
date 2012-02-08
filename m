Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2BHU0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:26:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2BHU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:26:38 -0500
Date: Wed, 08 Feb 2012 15:26:24 -0500 (EST)
Message-Id: <20120208.152624.1844477840327789365.davem@davemloft.net>
To: pmeerw@pmeerw.net
Cc: linux-kernel@vger.kernel.org, steve.glendinning@smsc.com,
        p.meerwald@bct-electronic.com
Subject: Re: [PATCH 1/2] smsc95xx: add module parameter to turn off NIC
 status leds
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
References: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 12:26:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>
Date: Wed,  8 Feb 2012 12:08:51 +0100

> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> add module parameter to allow to turn off NIC status leds (link, 
> speed, activity); blinking LEDs are annoying outside the server room :)
> 
> default behaviour is not changed, tested on beagleboard-xm
> 
> Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

No.  Create a generic mechanism, perhaps via ethtool, for users to
configure something like this.

Otherwise the next driver that wants to provide this kind of knob
will add yet another module parameter with yet another name, and
this kind of ad-hoc set of interfaces absolutely sucks for users.
