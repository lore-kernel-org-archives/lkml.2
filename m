Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0HMGq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:46:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:47375 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab0HMGqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:46:22 -0400
Date: Fri, 13 Aug 2010 15:45:31 +0900
To: geert@linux-m68k.org, sfr@canb.auug.org.au
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
References: <20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
	<20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
	<AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100813154056S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Aug 2010 15:45:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 11:03:37 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Seems Sun3 suffers from this as well:
> http://kisskb.ellerman.id.au/kisskb/buildresult/3022174/
> 
> <std_rant>
> Funny how these things never show up in linux-next...
> </std_rant>

Any chance to test the -mm tree on linux-next compile platform?
