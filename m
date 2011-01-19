Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1ASXLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:11:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab1ASXL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:11:28 -0500
Date: Wed, 19 Jan 2011 15:01:20 -0800
From: Greg KH <gregkh@suse.de>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Arun Thomas <arun.thomas@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi/me4000: fix sparse warning "obsolete
 struct initializer"
Message-ID: <20110119230120.GB23564@suse.de>
References: <1294697236-12016-1-git-send-email-peterhuewe@gmx.de>
 <201101182249.11127.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201101182249.11127.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 10:49:10PM +0100, Peter Hüwe wrote:
> Am Montag 10 Januar 2011, 23:07:16 schrieb Peter Huewe:
> > This patch fixes the sparse warnings in me4000.c:
> > me4000.c:122:1: warning: obsolete struct initializer, use C99 syntax
> > me4000.c:123:1: warning: obsolete struct initializer, use C99 syntax
> > me4000.c:124:1: warning: obsolete struct initializer, use C99 syntax
> > me4000.c:125:1: warning: obsolete struct initializer, use C99 syntax
> > by converting the struct to use C99 syntax
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
>  Ping - any updates on this one?

I have to wait until .38-rc1 before I can look at these.  Now that it is
out, I hope to get through my huge patch-queue by Friday, before I take
off on another trip...

Actually, that trip does provide a whole lot of uninterrupted plane
time, so that might be a bit better place to do this work...

thanks,

greg k-h
