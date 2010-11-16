Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab0KPHas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:30:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1428 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab0KPHar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:30:47 -0500
Subject: Re: [PATCH 09/10] drivers/staging: Remove unnecessary casts of
 netdev_priv
From: Joe Perches <joe@perches.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=1XasDJaaisZ=NnL3Yv5tx+vhuifCuq7e-0PMe@mail.gmail.com>
References: <cover.1289855436.git.joe@perches.com>
	 <223eff1b1e8c4d1791af56113d088b379a93780b.1289855436.git.joe@perches.com>
	 <AANLkTi=1XasDJaaisZ=NnL3Yv5tx+vhuifCuq7e-0PMe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 23:30:45 -0800
Message-ID: <1289892645.28741.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 08:20 +0100, Belisko Marek wrote:
> On Mon, Nov 15, 2010 at 10:12 PM, Joe Perches <joe@perches.com> wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> If I do: grep -r -n 'netdev_priv' drivers/staging/*/*[ch]

Try:

$ grep -rP --include=*.[ch] "=\s*\([^\*]+\*\s*\)\s*netdev_priv" drivers/staging

> there is a more netdev_priv occurences ;)

I'm sure there are, but probably not assigns.
If you find more unnecessary casts, by all means submit them.

cheers, Joe

