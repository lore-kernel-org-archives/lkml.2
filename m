Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0CYUY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:24:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45178
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab0CYUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:24:55 -0400
Date: Thu, 25 Mar 2010 13:25:19 -0700 (PDT)
Message-Id: <20100325.132519.165189904.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-23 - IPv6 warnings...
From: David Miller <davem@davemloft.net>
In-Reply-To: <4788.1269535530@localhost>
References: <12096.1269481001@localhost>
	<20100324184226.3bf42d8f.akpm@linux-foundation.org>
	<4788.1269535530@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Thu, 25 Mar 2010 12:45:30 -0400

> On Wed, 24 Mar 2010 18:42:26 EDT, Andrew Morton said:
>> On Wed, 24 Mar 2010 21:36:41 -0400 Valdis.Kletnieks@vt.edu wrote:
>> 
>> > On Tue, 23 Mar 2010 15:34:59 PDT, akpm@linux-foundation.org said:
>> > > The mm-of-the-moment snapshot 2010-03-23-15-34 has been uploaded to
>> > > 
>> > >    http://userweb.kernel.org/~akpm/mmotm/
>> > 
>> > Seen in my dmesg.  It may be relevant that I'm at home, and my IPv6
>> > prefix arrives via a PPP VPN connection. This happened about 20-25 seconds
>> > after I launched pppd.
>> 
>> Yes, thanks, I get the same - it doesn't seem to break anything.  It
>> also happens some time after boot has completed.
> 
> Just doing an 'ifup eth0' on a network with IPv6 on it is sufficient.

I'm going to look into this more deeply tonight.
