Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2ITWBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:01:54 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:31810 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752293Ab2ITWBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:01:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WiSWpBsnh0uIEb5MXw5j8
Date: Thu, 20 Sep 2012 15:01:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 sound-asoc tree
Message-ID: <20120920220143.GI28835@atomide.com>
References: <20120920160637.7f9065225982468c25fa1952@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920160637.7f9065225982468c25fa1952@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [120919 23:07]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got conflicts in
> sound/soc/omap/igep0020.c, sound/soc/omap/omap3beagle.c,
> sound/soc/omap/omap3evm.c and sound/soc/omap/overo.c between commit
> 152c6e56f6a8 ("ASoC: Remove obsolete OMAP3 machine drivers") from the
> sound-asoc tree and commit 2203747c9771 ("ARM: omap: move platform_data
> definitions") from the arm-soc tree.
> 
> The former removed the files, so I did that and can carry the fix as
> necessary (no action is required).

OK thanks again.

Tony
