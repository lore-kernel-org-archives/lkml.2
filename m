Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0JHAXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0JHAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:23:05 -0400
Date: Thu, 7 Oct 2010 17:22:44 -0700
From: Greg KH <gregkh@suse.de>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Bob Beers <bob.beers@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-07-14-08 uploaded
Message-ID: <20101008002244.GA6523@suse.de>
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
 <AANLkTi=UgODY9REO-f9hxRBT4iZqsFB2spdBTCqeUTk4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=UgODY9REO-f9hxRBT4iZqsFB2spdBTCqeUTk4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:17:54AM +0200, Zimny Lech wrote:
> Hi,
> 
> 2010/10/7  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
> 
>   LD      drivers/built-in.o
> drivers/staging/built-in.o:(.data+0x2490): multiple definition of `max_mtu'
> drivers/infiniband/built-in.o:(.data+0x6b30): first defined here
> make[2]: *** [drivers/built-in.o] Error 1
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2

This is a cxt1e1 driver issue.

Bob, care to fix this up?

thanks,

greg k-h
