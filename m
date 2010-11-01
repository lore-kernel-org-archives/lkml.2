Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0KAE6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 00:58:19 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:53942 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0KAE6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 00:58:17 -0400
From: Amit Salecha <amit.salecha@qlogic.com>
To: Denis Kirjanov <dkirjanov@kernel.org>, David Miller <davem@davemloft.net>
CC: "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 31 Oct 2010 23:56:28 -0500
Subject: RE: NULL pointer dereference at netxen_nic_probe+0x813/0x9a0
Thread-Topic: NULL pointer dereference at netxen_nic_probe+0x813/0x9a0
Thread-Index: Act4bI1pzFa2MQTxR/WhJArxkrMczwBFJdYF
Message-ID: <99737F4847ED0A48AECC9F4A1974A4B80FCEAB434C@MNEXMB2.qlogic.org>
References: <201010281250.50802.bjorn.helgaas@hp.com>
	<AANLkTim8coGDmxxCnhzXXLEswf1OYptswbA59BYcbp-N@mail.gmail.com>
	<4CCB24CA.3050106@kernel.org>
 <20101029.125403.71123384.davem@davemloft.net>,<4CCC7868.60104@kernel.org>
In-Reply-To: <4CCC7868.60104@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, thanks Dave, now I see.
>
> [PATCH] netxen_nic: Fix the tx queue manipulation bug in netxen_nic_probe
>
> We should not stop the egress queue during probe because it is wrong.
>
>Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> ---
> drivers/net/netxen/netxen_nic_main.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)

Thanks Denis, for fixing this.