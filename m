Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0HRMsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:48:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:53042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0HRMsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:48:04 -0400
Date: Wed, 18 Aug 2010 05:47:55 -0700
From: Greg KH <gregkh@suse.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging drivers das08_cs.c compile error
Message-ID: <20100818124755.GE4944@suse.de>
References: <AANLkTin5K=ii_ZhQ1hFm7wfcqfhdQhrUh-mXS7ZAy=h-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5K=ii_ZhQ1hFm7wfcqfhdQhrUh-mXS7ZAy=h-@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:07:05PM +0300, Anca Emanuel wrote:
> Linux 2.6.36-rc1 compile error:
> 
> drivers/staging/comedi/drivers/das08_cs.c: In function
> ?das08_pcmcia_config_loop?:
> drivers/staging/comedi/drivers/das08_cs.c:225: error: ?struct
> pcmcia_device? has no member named ?io?

Yeah, thanks, a patch has already been sent to me for this, I'll get it
to Linus soon.

thanks,

greg k-h
