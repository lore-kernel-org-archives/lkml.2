Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2CJTWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 14:22:44 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43566 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751840Ab2CJTWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 14:22:41 -0500
Message-ID: <1331407360.1762.8.camel@joe2Laptop>
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Anatolij Gustschin <agust@denx.de>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Date: Sat, 10 Mar 2012 11:22:40 -0800
In-Reply-To: <20120310184407.GB4139@pengutronix.de>
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
	 <20120310181315.GA4139@pengutronix.de>
	 <1331404377.14442.19.camel@joe2Laptop>
	 <20120310184407.GB4139@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-10 at 19:44 +0100, Wolfram Sang wrote:
> > Anatolij is not listed as a maintainer for this file
> > nor has he ever written or signed a patch for it.
> I noticed that Grant was in CC, assumed that it was because of his previous MPC
> maintainership and mentioned that Anatolij took over. Nothing more, just wanted
> to help.

Actually, it's because there's a K: of_get_property
line in OPEN FIRMWARE and the file has one.

I suppose that get_maintainers could be told to
ignore K: entries when using -f <file>.

> > It'd be possible to add patterns to MAINTAINERS
> > if Anatolij really wants to see changes to drivers.
> It seems a bit too much for my taste (hardly readable? false positives?),

There are no false positives as far as I can tell.
Just using *mpc5* doesn't give any either today.
It's perlish so the whole thing is gibberish anyway.


