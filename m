Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab0C2NWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:22:03 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50286 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0C2NWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:22:00 -0400
Date: Mon, 29 Mar 2010 15:21:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: build warning after merge of the i2c tree
Message-ID: <20100329152155.056741d2@hyperion.delvare>
In-Reply-To: <20100329105439.1e474095.sfr@canb.auug.org.au>
References: <20100329105439.1e474095.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 29 Mar 2010 10:54:39 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the ii2c tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/i2c/i2c-core.c:159: warning: 'i2c_legacy_suspend' defined but not used
> drivers/i2c/i2c-core.c:172: warning: 'i2c_legacy_resume' defined but not used
> 
> Introduced by commit 592b0bd0324728fe0aca823951eba06a9494c2f9 ("i2c: Fix
> bus-level power management callbacks").  These routines are only called
> if CONFIG_PM_SLEEP is defined.

Err, sorry. I noticed the problem and fixed it some days ago, but
forgot to refresh the patch before pushing it to you. This is fixed
now, thanks for the notice.

-- 
Jean Delvare
