Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab2HIEJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 00:09:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33991 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777Ab2HIEJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 00:09:44 -0400
Message-ID: <1344485382.2024.9.camel@joe2Laptop>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
From: Joe Perches <joe@perches.com>
To: "Ren, Cloud" <cjren@qca.qualcomm.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "Hao-Ran Liu(Joseph Liu)" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Date: Wed, 08 Aug 2012 21:09:42 -0700
In-Reply-To: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	 <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 02:27 +0000, Ren, Cloud wrote:
> Hi David,
[]
> The alx driver only supports two new nics(l1f/l2f) now.  It doesn't supersede atl1c driver.
> Atl1c driver still supports old nics.
[]
> -----Original Message-----
> From: Ren, Cloud 
> Sent: 2012年8月9日 18:15
[]
> This driver support two new ethernet chipsets:

[+400kb of entire original patch]

Did you really have to quote 400kb of original patch to
make that prefixing statement to David?

[]

> Signed-off-by: Joe Perches <joe@perches.com>
 
I would prefer my name not be listed as a Signed-off-by.

I don't have a card, I never tested it, etc.  What I did
do is a light review and made a couple of trivial patch
suggestions about how you might make logging code a bit
smaller.

Thanks and cheers, Joe

