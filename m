Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0HPQZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:25:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:60627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab0HPQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:25:10 -0400
Date: Mon, 16 Aug 2010 08:01:21 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty: add tty_struct->dev pointer to corresponding
	device instance
Message-ID: <20100816150121.GA13392@suse.de>
References: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com> <20100809160819.42e8c84e@lxorguk.ukuu.org.uk> <AANLkTinRVuP7GWo8mrGTy_DR1gv=od5-FQEEb4KO_YWo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinRVuP7GWo8mrGTy_DR1gv=od5-FQEEb4KO_YWo@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 02:57:28PM +0400, Dmitry Eremin-Solenikov wrote:
> Hello,
> 
> On Mon, Aug 9, 2010 at 7:08 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Mon, ?9 Aug 2010 18:22:49 +0400
> > Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
> >
> >> Some device drivers (mostly tty line disciplines) would like to have way
> >> know a struct device instance corresponding to passed tty_struct. Add
> >> a struct device pointer to struct tty_struct and populate it during
> >> initialize_tty_struct().
> >
> > Acked-by: Alan Cox <alan@linux.intel.com>
> >
> 
> Greg, what about these two patches? Can I expect for them to be pulled
> into your patch queue for 2.6.37?

Yes, I will queue them up to my -next branch soon and will go to Linus
for .37.

thanks,

greg k-h
