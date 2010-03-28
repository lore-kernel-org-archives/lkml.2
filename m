Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab0C1ETW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:19:22 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33344 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0C1ETV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:19:21 -0400
Date: Sat, 27 Mar 2010 20:32:29 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-23 - IPv6 warnings...
Message-ID: <20100327203229.1afd1531@nehalam>
In-Reply-To: <20100325.232349.66185070.davem@davemloft.net>
References: <4788.1269535530@localhost>
	<20100325.214050.101816448.davem@davemloft.net>
	<4161.1269584302@localhost>
	<20100325.232349.66185070.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 23:23:49 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Valdis.Kletnieks@vt.edu
> Date: Fri, 26 Mar 2010 02:18:22 -0400
> 
> > Confirming looks like a good fix - no cruft in dmesg, and I have ipv6 addresses:
> 
> Great, thanks for testing.
> 
> Andrew your box should be good now too.

Thanks for fixing this.

-- 
