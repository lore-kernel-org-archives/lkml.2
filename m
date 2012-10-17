Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2JQUcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:32:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab2JQUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:32:18 -0400
Date: Wed, 17 Oct 2012 13:32:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: jc@eclis.ch, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Message-ID: <20121017203214.GC30907@kroah.com>
References: <1348841764-26873-1-git-send-email-jc@eclis.ch>
 <16666667.izGXgx19Gh@linux-lqwf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16666667.izGXgx19Gh@linux-lqwf.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 09:42:32PM +0200, Oliver Neukum wrote:
> On Friday 28 September 2012 16:16:04 jc@eclis.ch wrote:
> > From: Jean-Christian de Rivaz <jc@eclis.ch>
> > 
> > This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
> > and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.
> > 
> > Reference:
> > http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5
> > 
> > Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
> Acked-by: Oliver Neukum <oneukum@SUSE.DE>
> 
> However, this went to the wrong list. Please repost to
> 
> davem@davemloft.net
> netdev@vger.kernel.org

No it isn't, this is the cdc-acm driver, not the wdm driver, it was sent
to the right list.  I'll pick it up now.

greg k-h
