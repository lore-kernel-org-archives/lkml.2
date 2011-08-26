Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1HZIH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:07:56 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51205 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752245Ab1HZIHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:07:51 -0400
Message-ID: <205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
In-Reply-To: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
Date: Fri, 26 Aug 2011 01:07:50 -0700
Subject: Re: linux-next: Tree for Aug 26 (i7core_edac)
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, August 25, 2011 10:00 pm, Stephen Rothwell wrote:
> Hi all,
>
> The powerpc allyesconfig build still fails today.
>
> Changes since 20110825:


on i386:

ERROR: "__udivdi3" [drivers/edac/i7core_edac.ko] undefined!

in both get_sdram_scrub_rate()
and set_sdram_scrub_rate()

-- 
~Randy

