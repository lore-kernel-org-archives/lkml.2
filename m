Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1CRDvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:51:11 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50872 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab1CRDvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:51:07 -0400
Date: Thu, 17 Mar 2011 20:50:31 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        matt mooney <mfm@muteddisk.com>
Subject: Re: linux-next: manual merge of the kbuild tree with the
 hwmon-staging tree
Message-ID: <20110318035031.GA8242@ericsson.com>
References: <20110318114836.04c76926.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110318114836.04c76926.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Mar 17, 2011 at 08:48:36PM -0400, Stephen Rothwell wrote:
> Hi Michal,
> 
> Today's linux-next merge of the kbuild tree got a conflict in
> drivers/hwmon/Makefile between commit 442aba78728e ("hwmon: PMBus device
> driver") from the hwmon-staging tree and commit 5c39e31195f4 ("hwmon:
> change to new flag variable") from the kbuild tree.
> 

Linus merged the hwmon-staging tree, so the conflicts should hopefully
be resolved in a day or so.

Thanks,
Guenter
