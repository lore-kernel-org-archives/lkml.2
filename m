Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab0GOQ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:28:11 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:60141 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933677Ab0GOQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:28:09 -0400
X-Greylist: delayed 115013 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 12:28:08 EDT
Date: Thu, 15 Jul 2010 18:28:05 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Zeno Davatz <zdavatz@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
Subject: Re: kmemleak, cpu usage jump out of nowhere
Message-ID: <20100715162805.GA10240@brouette>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
 <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
 <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
 <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
 <4C3D89AC.4040303@cs.helsinki.fi>
 <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
 <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
 <4C3F2F52.2050101@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3F2F52.2050101@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > I also did not have anymore hangs and random bad moods of my CPUs
> > that all of a sudden grab 100% of all 8 cores of my CPU power across
> > my machine since I disabled
> > CONFIG_NO_BOOTMEM:

* Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 18:54]:
> Interesting. Damien, does disabling CONFIG_NO_BOOTMEM fix you problem too?

I will test in the coming hours, and report back tomorrow... Just
recompiled 2.6.35-rc5-git1 with this option disabled.

-- 
Damien
