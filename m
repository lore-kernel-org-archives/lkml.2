Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0G0Qrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:47:36 -0400
Received: from kroah.org ([198.145.64.141]:39596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0G0Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:47:34 -0400
Date: Tue, 27 Jul 2010 09:47:17 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20100727164717.GB9541@kroah.com>
References: <20100727151843.7d253148.sfr@canb.auug.org.au>
 <20100727084353.5b14224a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727084353.5b14224a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 08:43:53AM +0100, Alan Cox wrote:
> On Tue, 27 Jul 2010 15:18:43 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > After merging the tty tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/serial/mfd.c:37:30: error: linux/serial_mfd.h: No such file or directory
> > drivers/serial/mfd.c: In function 'port_show_regs':
> > drivers/serial/mfd.c:166: error: 'UART_FOR' undeclared (first use in this function)
> > 
> > ... and on ... and on ...
> > 
> > Caused by commit c3190cf68dfc58c33de0fd59b919cbb864acbba4 ("hsu: driver
> > for Medfield High Speed UART device") and following.   Did it miss a file?
> > 
> > A little more care and testing, please.
> 
> Yes although I had a local copy so it built and tested beautifully 8(
> 
> Will send Greg and updated set of those patches versus todays -next

Now fixed up, sorry for missing this.

greg k-h
