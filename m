Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1CWA7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:59:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36160 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1CWA7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vLLsbSL1leh2hhwyIWY2kPULmqNQ80aZ6DggtTW0J5z40d98H/3TJQRSy65n67G5r8
         bTtISSZLH85T//KA0mTvl4THTMkIWpqLAxqGd78KAGv3vSJwMruc3dAJZWcyzhUnk/45
         YEpRPJ+X8WLQXpj7B0FF0SgqB6+eEFAsSvk5c=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com,
        Greg KH <greg@kroah.com>
In-Reply-To: <20110322162108.a4b70291.akpm@linux-foundation.org>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299947013.17988.0.camel@maxim-laptop> <1300219210.13493.0.camel@MAIN>
	 <20110315140402.334cc55c.akpm@linux-foundation.org>
	 <1300590545.15453.3.camel@maxim-laptop>
	 <20110319234701.0eab3744.akpm@linux-foundation.org>
	 <1300621371.15768.11.camel@maxim-laptop>
	 <20110322162108.a4b70291.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 02:59:34 +0200
Message-ID: <1300841974.3588.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 16:21 -0700, Andrew Morton wrote:
> On Sun, 20 Mar 2011 13:42:51 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Sat, 2011-03-19 at 23:47 -0700, Andrew Morton wrote:
> > > On Sun, 20 Mar 2011 05:09:05 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > 
> > 
> > ...
> >
> > Also, I don't have much time now to improve the ms_block driver till
> > this summer (studying).
> > The driver works. Yes it has a flaw in regard to scatterlist processing,
> > because I didn't find a better way to deal with this monster, but I will
> > fix that later. I am not the kind of guy that runs away after a merge.
> > It would be nice to just see my code in kernel, code I wrote more that a
> > year ago.
> > 
> > This flaw is purely theoretical. Driver does work.
> 
> Lots of code is "flawed but works".  The place for such code is
> drivers/staging/ - it gets put in there so the code is available for
> those who need the driver and the code is later moved over into
> drivers/ once the flaws have been addressed.
> 
> So a path forward here would be for us to put the driver and the
> sglist extensions into a directory under drivers/staging/.
Ok, I won't be fighting with you over this one.

However, I ask for this:


1. Please merge r592.c, it doesn't depend on anything.

2. Please review ms_block.c for other problems that might prevent merge.
For example when I published the sg list helpers, nobody told me that I
am not allowed to add them. Actually the opposite, I was told to put
them in scatterlist.c.
When I did so, again I was told that I didn't do the kerneldoc comments
right, and also was told to improve few of the functions.
Now I did all that, and I am told that scatterlist usage in my driver is
no-go. OK. But what else is there that you don't like?

Best regards,
	Maxim Levitsky



