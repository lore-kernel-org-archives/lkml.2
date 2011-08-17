Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1HQRCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:02:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42822 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1HQRCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:02:07 -0400
Subject: Re: linux-next: Tree for Aug 17 (EVM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        Kylene Hall <kjhall@us.ibm.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
In-Reply-To: <20110817094039.0bba7092.rdunlap@xenotime.net>
References: <20110817151628.93911903cac8f207e9f01457@canb.auug.org.au>
	 <20110817094039.0bba7092.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 13:00:45 -0400
Message-ID: <1313600445.4732.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 09:40 -0700, Randy Dunlap wrote:
> On Wed, 17 Aug 2011 15:16:28 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > The powerpc allyesconfig build still fails today.
> 
> warning: (EVM) selects TRUSTED_KEYS which has unmet direct dependencies (KEYS && TCG_TPM)
> 
> EVM should depend on TCG_TPM [or select it :( ].

Thanks Randy for bringing this to my attention.  It's preferable to use
a trusted key to encrypt/decrypt the EVM key, but for those systems
without a TPM, user type keys are supported.  I'll add the dependency
for now, but will look into a better solution.

> Can we get an EVM entry added to MAINTAINERS, please?
> 
> ---
> ~Randy

Will do.

thanks,

Mimi


