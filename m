Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1LSIVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:21:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1LSIVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:21:13 -0500
Date: Mon, 19 Dec 2011 09:21:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: linux-next: build failure after merge of the hid tree
In-Reply-To: <20111219123432.f58b93575c90cdbf62a08fbc@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1112190919570.8727@pobox.suse.cz>
References: <20111219123432.f58b93575c90cdbf62a08fbc@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Stephen Rothwell wrote:

> Hi Jiri,
> 
> After merging the hid tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/hid/Kconfig:37: syntax error
> drivers/hid/Kconfig:36: invalid option
> 
> Caused by commit 7e69ba7caeb0 ("HID: introduce proper dependency of
> HID_BATTERY on POWER_SUPPLY").
> 
> I am sure that this "==" v. "=" in Kconfig files was discussed last
> week ... :-(

How pathetic I am ... it was initially me who noticed that this is not 
going to work, just to do the very same mistake shortly afterwards.

Sorry about that. I have now pushed fixed branch.

-- 
Jiri Kosina
SUSE Labs
