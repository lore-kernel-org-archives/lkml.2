Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1BGPVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:21:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37799 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753372Ab1BGPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:21:35 -0500
Date: Mon, 7 Feb 2011 15:21:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207152132.GM10564@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110208011324.d5371c4c.sfr@canb.auug.org.au>
 <20110207141829.GK10564@opensource.wolfsonmicro.com>
 <20110208014432.2c9288e4.sfr@canb.auug.org.au>
 <20110207145031.GL10564@opensource.wolfsonmicro.com>
 <AANLkTikw7j5Q7CGZK=Xbcgubt9LYBGiXf01wQ4nbg8NR@mail.gmail.com>
 <20110208021045.699654ca.sfr@canb.auug.org.au>
 <20110208021916.68b33b37.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208021916.68b33b37.sfr@canb.auug.org.au>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 02:19:16AM +1100, Stephen Rothwell wrote:

> At least some of the powerpc defconfigs were added with CONFIG_PM
> disabled.  I assume that was on purpose (though it may not have been).

I'd not be so sure - since it's a bool without an explicit default set
Kconfig will default to disabling it and if anything enabling it is the
option that requires special effort.
