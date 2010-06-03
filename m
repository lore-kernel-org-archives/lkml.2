Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab0FCJs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:48:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45218
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758045Ab0FCJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:48:53 -0400
Date: Thu, 03 Jun 2010 02:49:02 -0700 (PDT)
Message-Id: <20100603.024902.139551876.davem@davemloft.net>
To: w.sang@pengutronix.de
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, grant.likely@secretlab.ca,
       linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
Subject: Re: [PATCH 2/2] of/crypto: n2_core: fix build breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1275537827-28921-2-git-send-email-w.sang@pengutronix.de>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
	<1275537827-28921-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>
Date: Thu,  3 Jun 2010 06:03:47 +0200

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Herbert you really need to push your pending crypto tree stuff to
Linus, this is the second time this build fix has been posted just
today alone and it's in your tree since last week :-)
