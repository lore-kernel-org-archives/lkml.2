Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1GDPNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:13:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1GDPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:13:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH for 3.0] AT91: Change nand buswidth logic to match hardware default configuration
Date: Mon, 4 Jul 2011 17:13:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, patrice.vilchez@atmel.com,
        linux-kernel@vger.kernel.org
References: <1309515924-22531-1-git-send-email-nicolas.ferre@atmel.com> <201107041625.25972.arnd@arndb.de> <4E11D123.9070409@atmel.com>
In-Reply-To: <4E11D123.9070409@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041713.23982.arnd@arndb.de>
X-Provags-ID: V02:K0:e8no0qWvTj/t52M/+odYxJbYUAj0BUzzGoaxhuzy4W3
 dm1gSrlJWiEYecGbKqdHgyL2Qq8kXNWCGGnD+ZcpmT7HITv8lQ
 6SfvxPZtYN1M4o4rT6FNcaXxbGqxvBrfaJ4iiMTHqy2BEJpKj4
 pCPgcnXbVO8C3duejzkxPi9cm9HAA1bkMdBn+nKibPnf/gfvq5
 mEK1d65e/c6Tzyi+yb60Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011, Nicolas Ferre wrote:
> > In this case, studying the patch more closely shows that it's
> > very harmless, but I'd rather not have to look that closely.
> 
> Well, in fact it is a fix against what was introduced in a 3.0 patch
> which I found to be wrong.
> The reason because I do not want to be in next kernel is the fact that
> it can puzzle the user (people that want to use kernel without changing
> the system_rev between 2.6.39 -> 3.0 and again revert their changes for
> 3.0 -> 3.1).
> 
> > Am I correct that the bug is a regression against 2.6.39?
> 
> No, in fact it was introduced during 3.0 early -rc.

That's what I mean by 'regression against 2.6.39': it was working in 2.6.39,
but later kernels are broken without this fix.

	Arnd
