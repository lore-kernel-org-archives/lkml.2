Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1HaG4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:56:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51798 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1HaG4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:56:51 -0400
Date: Wed, 31 Aug 2011 14:56:30 +0800
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
Subject: Re: [PATCH v3 10/18] Staging: cx25821: Fix long lines in
 cx25821-audio-upstream.c
Message-ID: <20110831145630.7950a105@inspire>
In-Reply-To: <20110830141250.GM3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
	<1314677833-4689-11-git-send-email-leonidsbox@gmail.com>
	<20110830141250.GM3705@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 17:12:50 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Aug 30, 2011 at 12:17:05PM +0800, Leonid V. Fedorenchik wrote:
> > @@ -603,7 +599,8 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
> >  	if (!dev)
> >  		return -1;
> >  
> > -	sram_ch = dev->channels[dev->_audio_upstream_channel_select].sram_channels;
> > +	sram_ch = dev->channels[dev->_audio_upstream_channel_select].
> > +			sram_channels;
> 
> $ echo -n "_audio_upstream_channel_select" | wc -c 
> 30
> 
> I think I may have found the problem.  (Don't use variable names that
> are a 30 zillion chars long).
Yes, it's long, but I don't really know how to make it shorter. Is
_audio_upstream_channel OK?

> 
> regards,
> dan carpenter
> 



Leonid V. Fedorenchik
