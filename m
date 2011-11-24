Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1KXP5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:57:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1KXP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:57:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
Date: Thu, 24 Nov 2011 15:55:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jamie Iles <jamie.iles@mathembedded.com>
References: <20111124115805.d2b5cdc699b9d6ed300b9c09@canb.auug.org.au>
In-Reply-To: <20111124115805.d2b5cdc699b9d6ed300b9c09@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241555.03715.arnd@arndb.de>
X-Provags-ID: V02:K0:kpcnYFzjzx4WVpgvFc6h0vI2dAriAWApB/uQYk9Uslr
 MXAmPDHElTDhE40kCaNuMtkBPXlR5Egg4XSXlK3jryegkXkRI8
 Ry7uPo+z0CyJ90rwjc9YCM1K2I5f74zHTvari5Mqgw9tVHOBHF
 XBG82CIvnoaByBaC615i6pn30izCC7ofxRo7Qz6yFEuhIW7RbB
 +vR7BLfPS4D3d7K3uMh3lhyzwyYHuQPMAg4D3KyTcAP/PfDckK
 GKPzyMm+0W2MmhPLP93hncu9Z6uBDJqJSCpttIB5og2HftXUyl
 V4+Rkax7+hiz7zmy8R4yoEFHAQR8aNkiXl77q1Re4/q2ee6Ex6
 V8dhCtUS+KkiQ3QPXnUI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 November 2011, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/net/ethernet/cadence/Kconfig between commit eccab1ec87d0
> ("net/cadence: enable by default NET_ATMEL") from Linus' tree and commit
> f75ba50bdc2b ("macb: initial support for Cadence GEM") from the arm-soc
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Yes, looks good.

Thanks,

	Arnd
