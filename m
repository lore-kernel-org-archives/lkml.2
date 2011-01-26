Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1AZM5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:57:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1AZM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:57:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 14/20] staging/appletalk: remove the BKL
Date: Wed, 26 Jan 2011 13:57:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-15-git-send-email-arnd@arndb.de> <20110125.142926.246535705.davem@davemloft.net>
In-Reply-To: <20110125.142926.246535705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101261357.38132.arnd@arndb.de>
X-Provags-ID: V02:K0:Apn4EdYLnVpoI0vDWpnRmJuCGG94RUjGUwMG9Tj0C0v
 nPig9vhSsXKJ+K3Kva6jQSzZBFmv8Btn2E3BHeCIm9pjToWMuL
 SmgBfzkkcMgoDUlWeCG3wmOns32gM3+9COvji/onUxm05NTeTU
 LQ+DAPuQldrCv4ciLZzV06qyZqQcqioe61GwWYXYdvAh6Ek+pL
 FwuUoLrGgHl5jxy9E3Eyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 January 2011, David Miller wrote:
> If you're moving appletalk to staging because "nobody is motivated
> enough to remove the BKL" and then you actually do the work to remove
> the BKL, I really don't see any point in doing the whole staging
> thing.
> 
> We always keep an eye on every protocol that sits under the top-level
> net/.  Every socket API change propagates, as does every other
> networking API change that matters for those protocols.

Ok, fair enough. I've removed the "move to staging" patch now from my
series. I'm going to need some help with testing, or at least thoroughly
reviewing the patch, since I am not extremely confident in my own work
there.

	Arnd
