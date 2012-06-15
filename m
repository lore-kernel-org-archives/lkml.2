Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2FORzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:55:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2FORzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:55:02 -0400
Date: Fri, 15 Jun 2012 10:54:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: Need of automatic scripts for beginners
Message-ID: <20120615175458.GA32230@kroah.com>
References: <CAHkwNTnsVW6psWORXAEWVeQ+-ZQauY43SbE0P+be3FQD61PaOA@mail.gmail.com>
 <20120615034410.GA6380@kroah.com>
 <1339755916.2559.53.camel@twins>
 <CAHkwNTnk553D2m7tuGXN-CYFPv0Wk0xg_PX_Sq9D9CgPa2gj=A@mail.gmail.com>
 <1339780506.2559.89.camel@twins>
 <CAHkwNT=48TEG7DrG0L5XTCA7Rbi-rTLiXTc4Wrt_b=fB=4jBVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwNT=48TEG7DrG0L5XTCA7Rbi-rTLiXTc4Wrt_b=fB=4jBVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:20:56PM +0530, Anil Nair wrote:
> Hi Peter,
> > It comes with your distro.. all I was saying is that they're not always
> > as useful as one might want them to be.
> 
> Which distro are you using? If anyone can make a general menudriven
> bash scirpt with all the compilation options and with proper
> documentation that would be good. If its not recommended then its ok.
> I just intended those who begineers have no clue where to begin with i
> had difficult trying to compile and configuring the kernel in the
> beginning.

You do know that there's a book out there, "Linux Kernel in a Nutshell",
which is free online, that describes how to do all of this?  Why not
look at that?

Also, each distro has their own install kernel script, some works better
than others.  I know the distros I use work just fine :)

thanks,

greg k-h
