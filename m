Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0I2G1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:27:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0I2G1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:27:02 -0400
Date: Tue, 28 Sep 2010 23:27:22 -0700 (PDT)
Message-Id: <20100928.232722.189705899.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
        john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 4/7] net: emaclite: Add support for little-endian
 platforms
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100929061146.GA2439@angua.secretlab.ca>
References: <1285739538-29058-4-git-send-email-monstr@monstr.eu>
	<1285739538-29058-5-git-send-email-monstr@monstr.eu>
	<20100929061146.GA2439@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Sep 2010 15:11:46 +0900

> On Wed, Sep 29, 2010 at 03:52:15PM +1000, Michal Simek wrote:
>> Upcomming Microblaze is little endian that's why is necessary
>> to fix protocol and length loading.
>> 
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> CC: "David S. Miller" <davem@davemloft.net>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> CC: Eric Dumazet <eric.dumazet@gmail.com>
>> CC: netdev@vger.kernel.org
>> CC: linux-kernel@vger.kernel.org
>> CC: devicetree-discuss@lists.ozlabs.org
> 
> This should go via davem, but it looks correct to me.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

It doesn't need to, the microblaze guys can integrate this directly:

Acked-by: David S. Miller <davem@davemloft.net>
