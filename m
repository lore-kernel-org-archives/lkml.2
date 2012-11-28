Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2K1E3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 23:29:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:58017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2K1E3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 23:29:08 -0500
Message-ID: <1354076916.2179.99.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ashley Lai <adlai@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 15:28:36 +1100
In-Reply-To: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
References: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 14:03 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the powerpc tree, next-20121115's build (powerpc
> allmodconfig) failed like this:
> 
> ERROR: ".of_reconfig_notifier_register" [drivers/crypto/nx/nx-compress.ko] undefined!
> ERROR: ".of_reconfig_notifier_unregister" [drivers/crypto/nx/nx-compress.ko] undefined!
> 
> Caused by commit 1cf3d8b3d24c ("powerpc+of: Add of node/property
> notification chain for adds and removes").

That nx stuff should just have gone through the powerpc tree... that's
not the first time it trips on generic changes because we miss it
being in the crypto tree...

Ashley, Nathan, who owns that ? Can you come up with a fixup patch ?

Ben.


