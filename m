Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab0HNHkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:40:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:33586 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab0HNHkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:40:18 -0400
Date: Sat, 14 Aug 2010 16:39:15 +0900
To: sfr@canb.auug.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, geert@linux-m68k.org,
        heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100813172752.4acd7089.sfr@canb.auug.org.au>
References: <AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
	<20100813154056S.fujita.tomonori@lab.ntt.co.jp>
	<20100813172752.4acd7089.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100814163804N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Aug 2010 16:39:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 17:27:52 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > Any chance to test the -mm tree on linux-next compile platform?
> 
> We do, I just have to remember to import the -mm tree manually.
> 
> See: http://kisskb.ellerman.id.au/kisskb/branch/14/

Ah, thanks! Seems that I need to track that.


> Even better would be to get most of the -mm tree into linux-next
> itself ... ;-)

Yeah, is there any way to push patches into both -mm and linux-next?
