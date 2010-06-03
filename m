Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab0FCKUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:20:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55462
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933671Ab0FCKUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:20:04 -0400
Date: Thu, 03 Jun 2010 03:20:14 -0700 (PDT)
Message-Id: <20100603.032014.254839306.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipconfig: document DHCP hostname and DNS record
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100603020244.GB4461@localhost>
References: <20100602.070531.73368509.davem@davemloft.net>
	<20100602185601.GB14221@basil.fritz.box>
	<20100603020244.GB4461@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>
Date: Thu, 3 Jun 2010 10:02:44 +0800

> ipconfig: document DHCP hostname and DNS record
> 
> Now it's possible to update the DNS record for $HOST_NAME with
> 
> 	ip=::::$HOST_NAME::dhcp
> 
> CC: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Applied.
