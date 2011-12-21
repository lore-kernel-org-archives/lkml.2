Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1LUV7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:59:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55964 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1LUV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:59:12 -0500
Date: Wed, 21 Dec 2011 16:58:05 -0500 (EST)
Message-Id: <20111221.165805.154231675155275590.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: sparc: __mcount_loc already exists
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdUvnTWvaTndObFjA_pJXNWVpDBqxviyDpYvihc7pDiV3Q@mail.gmail.com>
References: <CAMuHMdUvnTWvaTndObFjA_pJXNWVpDBqxviyDpYvihc7pDiV3Q@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 13:58:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 21 Dec 2011 08:59:03 +0100

> On Wed, Dec 21, 2011 at 08:51, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> Note that I deleted 5238 lines about "__mcount_loc already exists", to avoid
>> my email being rejected.
> 
> I anyone planning to fix this? It only happens for sparc64/sparc-allmodconfig,
> and appeared in v3.2-rc3.
> 
> linus: http://kisskb.ellerman.id.au/kisskb/buildresult/5167232/
> linux-next: http://kisskb.ellerman.id.au/kisskb/buildresult/5166753/

I'll look into this, thanks.
