Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0IUNgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:36:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab0IUNgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:36:05 -0400
Date: Tue, 21 Sep 2010 06:31:31 -0700
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the
 staging-next tree
Message-ID: <20100921133131.GB2751@suse.de>
References: <20100921160637.c61d4322.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921160637.c61d4322.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:06:37PM +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> Today's linux-next merge of the bkl-llseek tree got conflicts in
> drivers/staging/batman-adv/icmp_socket.c and
> drivers/staging/batman-adv/bat_debugfs.c between commit
> 2d77bb592f6cabc5ee5322c03ee92b9f96c45f60 ("Staging: batman-adv: Mark
> debugfs files as nonseekable") from the staging-next tree and commit
> 5295184fb318693b4ef2cd8056bf1a7cb43586d7 ("llseek: automatically
> add .llseek fop") from the bkl-llseek tree.
> 
> I used the versions from the staging-next tree.

That sounds correct, thanks for letting us know.

greg k-h
