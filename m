Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1KJRiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:38:07 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:6172 "EHLO
	AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958Ab1KJRiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:38:06 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 12:38:05 EST
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Thu, 10 Nov 2011 10:46:11 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH 14/17] powerpc/e500: Don't make kgdb use
 e500v1/e500v2 registers on e500mc
Message-ID: <20111110164611.GB11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-15-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320883635-17194-15-git-send-email-Kyle.D.Moffett@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BOn Wed, Nov 09, 2011 at 07:07:12PM -0500, Kyle Moffett wrote:
> The only systems which need the sparse PowerPC register map are the
> e500v1/e500v2.

Is this due to SPE?

> +/*
> + * On FreeScale e500v1 or e500v2 processors we need to skip some register
> + * sections, so just add up a list of what we need to store.
> + *
> + * On all other 32-bit PowerPC we can just pick the last needed register.
> + */

The "s" in "Freescale" is not capitalized, BTW.

-Scott

