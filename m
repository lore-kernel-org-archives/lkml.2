Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1GFV1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:27:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab1GFV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:27:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
Date: Wed, 6 Jul 2011 23:26:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux@arm.linux.org.uk,
        Barry Song <21cnbao@gmail.com>, workgroup.linux@csr.com,
        Olof Johansson <olof@lixom.net>, tglx@linutronix.de,
        weizeng.he@csr.com,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com> <1309984979-8847-2-git-send-email-robherring2@gmail.com> <20110706210237.GB5371@ponder.secretlab.ca>
In-Reply-To: <20110706210237.GB5371@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062326.53737.arnd@arndb.de>
X-Provags-ID: V02:K0:b2f8HjR8wRE7KcXY8KeXl+B3oZtOCd0Yr+G2u8W9fN1
 PCtJP3SkyZlovcHq5pOeB/2aF7FslhtTXJktjNrgLsN0SoxstF
 qxebxMuEAsXd4F0cTYQHVWW/4rpqxoMKQnonscBA7GiHGnCWoY
 FqWQZRVvj6BTn3FE44ejl/8I+rW95BUXeLR03UkXsLgKtAJsSW
 P93pBCrOTaZBuD516Dhkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011 23:02:37 Grant Likely wrote:
> 
> On Wed, Jul 06, 2011 at 03:42:59PM -0500, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > This adds probing for ARM L2x0 cache controllers via device tree. Support
> > includes the L210, L220, and PL310 controllers. The binding allows setting
> > up cache RAM latencies and filter addresses (PL310 only).
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> By rights, this should go via the arm tree, but it depends on patches
> that are already in devicetree/next.  Arnd, how do you want to handle
> this?  I want to avoid rebasing devicetree/next.

It's outside of the scope of the arm-soc tree really, the l2x0 code
is clearly core arm stuff, so it belongs into Russell's tree.

I think it's best if Russell can provide an Ack for this and you
put it in the tree that already has the dependencies.

	Arnd
