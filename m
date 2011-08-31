Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1HaG0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:26:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60817 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1HaG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:26:38 -0400
Date: Wed, 31 Aug 2011 14:26:15 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Youquan Song <youquan.song@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@linuxdriverproject.org,
        Joe Perches <joe@perches.com>, Ilya Gorskin <Revent82@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH v3 05/18] Staging: cx25821: Fix wrong brace placement in
 cx25821-cards.c
Message-ID: <20110831142615.515e8837@inspire>
In-Reply-To: <20110830140532.GK3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
	<1314677833-4689-6-git-send-email-leonidsbox@gmail.com>
	<20110830140532.GK3705@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 17:05:32 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Aug 30, 2011 at 12:17:00PM +0800, Leonid V. Fedorenchik wrote:
> > Fix wrong brace placement in cx25821-cards.c
> > 
> > Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
> > ---
> >  drivers/staging/cx25821/cx25821-cards.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
> > index 94e8d68..876345a 100644
> > --- a/drivers/staging/cx25821/cx25821-cards.c
> > +++ b/drivers/staging/cx25821/cx25821-cards.c
> > @@ -39,14 +39,14 @@ struct cx25821_board cx25821_boards[] = {
> >  			   .name = "UNKNOWN/GENERIC",
> >  			   /* Ensure safe default for unknown boards */
> >  			   .clk_freq = 0,
>                            ^^^^^^^^^^^^^
> You may as well pull these in an indent level while you're at it.
OK. Didn't think about it. Thanks.
> 
> > -			   },
> > +	},
> 
> regards,
> dan carpenter
> 



Leonid V. Fedorenchik
