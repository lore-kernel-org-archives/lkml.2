Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0FWPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:00:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34801 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0FWPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:00:15 -0400
Date: Wed, 23 Jun 2010 10:57:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless tree
Message-ID: <20100623145703.GD15205@tuxdriver.com>
References: <20100623125149.bdd7b1e6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623125149.bdd7b1e6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:51:49PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "mesh_handler_def" [drivers/net/wireless/libertas/libertas.ko] undefined!
> 
> Caused by commit cbca36ab906ce8c8d959eca1e0b5465e9182b0f0 ("Libertas:
> cfg80211 support") which removed mesh_handler_def even though there is
> still a reference to it in drivers/net/wireless/libertas/mesh.c when
> WIRELESS_EXT is defined.
> 
> I have used the wireless tree from next-20100622 for today.

Yes, sorry about that!  I'll correct it today.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
