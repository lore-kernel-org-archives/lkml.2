Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0HBNrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0HBNrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:47:37 -0400
Date: Mon, 2 Aug 2010 09:47:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, trenn@suse.de
Subject: Re: Boot-time dynamic debugging?
Message-ID: <20100802134705.GA2836@redhat.com>
References: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 03:10:40PM +0300, Pekka Enberg wrote:
> Hi!
> 
> Commit 346e15beb5343c2eb8216d820f2ed8f150822b08 ("driver core: basic
> infrastructure for per-module dynamic debug messages") removed
> "dynamic_printk" kernel parameter from the dynamic debugging subsystem
> (and forgot to update Documentation/kernel-parameters.txt). How can I
> use the new subsystem for enabling boot-time dev_dbg() calls for
> non-modular kernels?
> 
>                         Pekka

Hi Pekka,

Right now, you can not enable them dynamically from the boot command
line (only via the debugfs file). However, Thomas Renninger, has posted
a series to add back the boot-time functionality, see:

Subject:    [patch 0/3] Dynamic Debug providing early boot debug messages via
boot parameter
http://marc.info/?l=linux-kernel&m=127970474426120&w=2

So I intend to queue those up for 2.6.36, and also update the
documentation.

thanks,

-Jason



