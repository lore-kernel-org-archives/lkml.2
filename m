Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031897Ab2COQqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:46:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48786 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031870Ab2COQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:46:28 -0400
Date: Thu, 15 Mar 2012 09:46:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
Message-ID: <20120315164624.GB25159@kroah.com>
References: <20120312203451.GA16773@kroah.com>
 <4F61C911.5010204@suse.cz>
 <4F62186E.4050806@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62186E.4050806@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:27:26PM +0100, Jiri Slaby wrote:
> On 03/15/2012 11:48 AM, Jiri Slaby wrote:
> > On 03/12/2012 09:34 PM, Greg KH wrote:
> >> I'm announcing the release of the 3.0.24 kernel.
> > ...
> >> Heiko Carstens (1): compat: fix compile breakage on s390
> > 
> > It looks like we need the same fix as for 2.6.32.59:
> > arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
> > arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
> > (first use in this function)
> > arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
> > reported only once
> > arch/s390/kernel/setup.c:328: error: for each function it appears in.)
> 
> And when that one is fixed, there is another error:
> drivers/s390/char/fs3270.c: In function 'fs3270_ioctl':
> drivers/s390/char/fs3270.c:335: error: implicit declaration of function
> 'compat_ptr'
> drivers/s390/char/fs3270.c:335: warning: assignment makes pointer from
> integer without a cast

Ick, have a patch for this?

thanks,

greg k-h
