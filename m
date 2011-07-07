Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1GGNob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:44:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56357 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab1GGNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:44:28 -0400
X-Sasl-enc: KiAEzvfuF/iZ1SVjhb3UlqjBUeryemylTHbQKXj7TVdK 1310046267
Date: Thu, 7 Jul 2011 06:42:29 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the ux500-core
 tree
Message-ID: <20110707134229.GA26939@kroah.com>
References: <20110707154223.d7ecda2a6cc84e033bb0b26a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707154223.d7ecda2a6cc84e033bb0b26a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:42:23PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> arch/arm/mach-ux500/board-mop500-u8500uib.c between commit 0df7aaf0f276
> ("mach-ux500: fix build error due to unknown 'regulator_en' field") from
> the ux500-core tree and commit 857f727674f4 ("staging: ste_rmi4: remove
> cross-dependent platform data") from the staging tree.
> 
> The second supercedes the first, so I used that.

That sounds correct, thanks for doing this.

greg k-h
