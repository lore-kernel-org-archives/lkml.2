Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2AESjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:39:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:47713 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2AESjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:39:31 -0500
Subject: Re: [PATCH] fsl/mpic: Document and use the "big-endian" device-tree flag
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1324571123-11577-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 5 Jan 2012 12:35:30 -0600
Cc: linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DE2E2CDA-D373-4E48-82EA-B8E1F05236D9@kernel.crashing.org>
References: <1324571123-11577-1-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 22, 2011, at 10:25 AM, Kyle Moffett wrote:

> The MPIC code checks for a "big-endian" property and sets the flag
> MPIC_BIG_ENDIAN if one is present.  Unfortunately, the PowerQUICC-III
> compatible device-tree does not specify it, so all of the board ports
> need to manually set that flag when calling mpic_alloc().
> 
> Document the flag and add it to the pq3 device tree.  Existing code
> will still need to pass the MPIC_BIG_ENDIAN flag because their dtb may
> not have this property, but new platforms shouldn't need to do so.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
> .../devicetree/bindings/powerpc/fsl/mpic.txt       |    9 ++++++++-
> arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    1 +
> 2 files changed, 9 insertions(+), 1 deletions(-)

need to update arch/powerpc/boot/dts/fsl/qoriq-mpic.dtsi

- k
