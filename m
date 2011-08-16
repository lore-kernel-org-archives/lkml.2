Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1HPSBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:01:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1HPSBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:01:44 -0400
Date: Tue, 16 Aug 2011 10:57:50 -0700
From: Greg KH <gregkh@suse.de>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: Annotate devtmpfsd as __init
Message-ID: <20110816175750.GA25099@suse.de>
References: <1313515355-28920-1-git-send-email-fabio.estevam@freescale.com>
 <CACqU3MU2f17tb_5jjtT6TG0jw4P5JzR7=774QOoJ_T01wSmXHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MU2f17tb_5jjtT6TG0jw4P5JzR7=774QOoJ_T01wSmXHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 01:30:06PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Tue, Aug 16, 2011 at 1:22 PM, Fabio Estevam
> <fabio.estevam@freescale.com> wrote:
> > This fixes the following:
> >
> > WARNING: vmlinux.o(.text+0x1ed41c): Section mismatch in reference from the function devtmpfsd() to the (unknown reference) .init.data:(unknown)
> > The function devtmpfsd() references
> > the (unknown reference) __initdata (unknown).
> > This is often because devtmpfsd lacks a __initdata
> > annotation or the annotation of (unknown) is wrong.
> >
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> >
> I already submitted a patch for that https://patchwork.kernel.org/patch/996132/

And it's in linux-next, right?

thanks,

greg k-h
