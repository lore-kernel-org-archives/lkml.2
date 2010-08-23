Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0HWI7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:59:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:49601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0HWI7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:59:15 -0400
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard
 page
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <AANLkTinGnUaWJbrV7Jcy+Uiu682uE6_2eHr0T3km+ihf@mail.gmail.com>
References: <20100818203143.735033743@clark.site>
	 <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
	 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
	 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
	 <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
	 <1282326182.29609.789.camel@localhost.localdomain>
	 <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com>
	 <AANLkTimTZKzXfBJCbzCyq3LwKvn3aCqyHjd5VXhnejfV@mail.gmail.com>
	 <1282336944.2605.1395.camel@laptop>
	 <AANLkTimmo2Z174ZG9o0X8HSvzgnc8NTVmkJ6C33BMCda@mail.gmail.com>
	 <AANLkTinGnUaWJbrV7Jcy+Uiu682uE6_2eHr0T3km+ihf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 10:58:27 +0200
Message-ID: <1282553907.2605.1491.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 14:24 -0700, Linus Torvalds wrote:
> Still. A doubly-linked list is totally trivial, and I just bet I have
> a bug in there somewhere. But looking at your 2007 patch and mine
> side-by-side, I do think mine is still less scary. 

For sure, and if you need it in a hurry your patch is much saner.

So if you feel like its required for .36 go for it, we can look at
cleaning it up for .37 or somesuch.


