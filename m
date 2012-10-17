Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2JQUco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:32:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2JQUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:32:42 -0400
Date: Wed, 17 Oct 2012 13:32:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean-Christian de Rivaz <jc@eclis.ch>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Message-ID: <20121017203239.GD30907@kroah.com>
References: <1348841764-26873-1-git-send-email-jc@eclis.ch>
 <16666667.izGXgx19Gh@linux-lqwf.site>
 <20121010222906.GA12493@cube>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010222906.GA12493@cube>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:29:06AM +0200, Jean-Christian de Rivaz wrote:
> On Wed, Oct 10, 2012 at 09:42:32PM +0200, Oliver Neukum wrote:
> > On Friday 28 September 2012 16:16:04 jc@eclis.ch wrote:
> > > From: Jean-Christian de Rivaz <jc@eclis.ch>
> > > 
> > > This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
> > > and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.
> > > 
> > > Reference:
> > > http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5
> > > 
> > > Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
> > Acked-by: Oliver Neukum <oneukum@SUSE.DE>
> > 
> > However, this went to the wrong list. Please repost to
> > 
> > davem@davemloft.net
> > netdev@vger.kernel.org
> > 
> > 	Regards
> > 		Oliver
> > 
> 
> Sorry for the wrong list, I used the scripts/get_maintainer.pl to get the
> destinations, as recommanded in Documentation/SubmittingPatches. Is there
> something to be fixed there or should I use an other procedure to get the
> right destinations?
> 
> I will rebase and repost the patch.

No need, you did this correctly.

greg k-h
