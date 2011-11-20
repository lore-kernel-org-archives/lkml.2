Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1KTQb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 11:31:28 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:35713 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1KTQb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 11:31:26 -0500
X-Spam-Flag: NO
X-Spam-Score: -3.175
Message-ID: <4EC92B5D.6000607@openwrt.org>
Date: Sun, 20 Nov 2011 17:31:25 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: ath79: Use kmemdup rather than duplicating its
 implementation
References: <1321569820.1624.273.camel@localhost.localdomain>
In-Reply-To: <1321569820.1624.273.camel@localhost.localdomain>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011.11.17. 23:43 keltezéssel, Thomas Meyer írta:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

Acked-by: Gabor Juhos <juhosg@openwrt.org>
