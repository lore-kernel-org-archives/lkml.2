Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2IXPjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:39:10 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:47366 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756271Ab2IXPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:39:08 -0400
Message-ID: <50607E99.6040303@xenotime.net>
Date: Mon, 24 Sep 2012 08:39:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 24 (irqchip)
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
In-Reply-To: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 07:53 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Today was a train wreck, with lots of new conflicts across several trees
> and a few build failures as well.


I agree.  I mostly get this:

drivers/Kconfig:157: can't open file "drivers/irqchip/Kconfig"

i.e., no such file.

How does this happen?  :(

who handles irqchip?

> -- 

~Randy
