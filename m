Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1CVXVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:21:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab1CVXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:21:21 -0400
Date: Tue, 22 Mar 2011 16:21:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
Message-Id: <20110322162108.a4b70291.akpm@linux-foundation.org>
In-Reply-To: <1300621371.15768.11.camel@maxim-laptop>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	<1299947013.17988.0.camel@maxim-laptop>
	<1300219210.13493.0.camel@MAIN>
	<20110315140402.334cc55c.akpm@linux-foundation.org>
	<1300590545.15453.3.camel@maxim-laptop>
	<20110319234701.0eab3744.akpm@linux-foundation.org>
	<1300621371.15768.11.camel@maxim-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Mar 2011 13:42:51 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sat, 2011-03-19 at 23:47 -0700, Andrew Morton wrote:
> > On Sun, 20 Mar 2011 05:09:05 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> 
> ...
>
> Also, I don't have much time now to improve the ms_block driver till
> this summer (studying).
> The driver works. Yes it has a flaw in regard to scatterlist processing,
> because I didn't find a better way to deal with this monster, but I will
> fix that later. I am not the kind of guy that runs away after a merge.
> It would be nice to just see my code in kernel, code I wrote more that a
> year ago.
> 
> This flaw is purely theoretical. Driver does work.

Lots of code is "flawed but works".  The place for such code is
drivers/staging/ - it gets put in there so the code is available for
those who need the driver and the code is later moved over into
drivers/ once the flaws have been addressed.

So a path forward here would be for us to put the driver and the
sglist extensions into a directory under drivers/staging/.
