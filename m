Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1GQJSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:18:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46763 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab1GQJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:18:29 -0400
X-Sasl-enc: 2DOU1+Q9TGPSBaxDhI0mPF/14/jc41W5mo4M6FKl0agT 1310894307
Date: Sun, 17 Jul 2011 11:16:00 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the staging tree with the trivial
 tree
Message-ID: <20110717091600.GD25824@kroah.com>
References: <20110716225343.4a0a0472fb944c9ba79f9590@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716225343.4a0a0472fb944c9ba79f9590@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 10:53:43PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/generic_serial/ser_a2232.c between commit 28f65c11f2ff
> ("treewide: Convert uses of struct resource to resource_size(ptr)") from
> the trivial tree and commit bb2a97e9ccd5 ("Staging: delete generic_serial
> drivers") from the staging tree.
> 
> The latter removes the file, so I did that.

Thank you, that is the correct fix :)
