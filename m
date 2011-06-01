Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023Ab1FADbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:31:06 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:50810
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933173Ab1FADbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:31:03 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 1 Jun 2011 11:35:54 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Chris Ball <cjb@laptop.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
Message-ID: <20110601033552.GA1902@S2100-06.ap.freescale.net>
References: <20110601111320.07b07b7f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110601111320.07b07b7f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jun 01, 2011 at 11:13:20AM +1000, Stephen Rothwell wrote:
> Hi Chris,
> 
> Today's linux-next merge of the mmc tree got a conflict in
> drivers/mmc/host/sdhci-of-core.c between commit b1608d69cb80
> ("drivercore: revert addition of of_match to struct device") from Linus'
> tree and commit e2d0d7dc5542 ("mmc: sdhci: make sdhci-of device drivers
> self registered") from the mmc tree.
> 
> The latter removes the file, so I did that (I *think* that the change
> from the former is no longer needed, but someone should check).

Yes, the change of b1608d69cb80 ("drivercore: revert addition of
of_match to struct device") is no longer needed.

-- 
Regards,
Shawn

