Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0IXLjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:39:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18398 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0IXLjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:39:48 -0400
Date: Fri, 24 Sep 2010 13:39:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mikael Pettersson <mikpe@it.uu.se>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [BUG 2.6.36-rc5] of_i2c.ko <-> i2c-core.ko dependency loop
Message-ID: <20100924133932.4320b993@endymion.delvare>
In-Reply-To: <19612.33369.175358.879889@pilspetsen.it.uu.se>
References: <19611.16302.262307.129176@pilspetsen.it.uu.se>
	<20100923113807.4643fbbb.rdunlap@xenotime.net>
	<19611.46496.782340.466509@pilspetsen.it.uu.se>
	<20100923150559.9c67da11.rdunlap@xenotime.net>
	<20100924111209.3c071da3@endymion.delvare>
	<19612.33369.175358.879889@pilspetsen.it.uu.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

On Fri, 24 Sep 2010 12:50:01 +0200, Mikael Pettersson wrote:
> Jean Delvare writes:
>  > As far as I can see this is caused by this commit from Grant:
>  > 
>  > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5
>  > 
>  > Mikael, can you please try reverting this patch and see if it solves
>  > your problem?
> 
> Yes, reverting the above commit from 2.6.36-rc5 eliminated the warnings,
> and I was able to insmod the i2c-{core,dev,powermac}.ko modules.

Thanks for testing and reporting. Grant, unless you come up with a fix
very quickly, I'll have to revert
959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5 for 2.6.36.

-- 
Jean Delvare
