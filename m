Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab2IUW4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:56:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab2IUWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:55:35 -0400
Date: Fri, 21 Sep 2012 15:55:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, devel@driverdev.osuosl.org,
        Marcus Karlsson <mk@acc.umu.se>, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] staging: zcache: fix spelling of comment
Message-ID: <20120921225516.GA4531@kroah.com>
References: <1346531386-9524-1-git-send-email-mk@acc.umu.se>
 <20120905160555.GA12339@phenom.dumpdata.com>
 <20120921154550.GB4780@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921154550.GB4780@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:45:51AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Sep 05, 2012 at 12:05:55PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Sat, Sep 01, 2012 at 10:29:46PM +0200, Marcus Karlsson wrote:
> > > Fix spelling in tmem.c:
> > > Transcedent -> Transcendent
> > > 
> > > Signed-off-by: Marcus Karlsson <mk@acc.umu.se>
> > 
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Greg, can you pick this up for 3.7 pls? Or should I prep a git branch
> to send to you (I've a patch for the TODO file as well).

No need for a git branch, just send me the patches in email, as that's
the format I need them in.

Please resend this one, as I don't want to dig it out of this thread by
hand :(

thanks,

greg k-h
