Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0IGD6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:58:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61725 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0IGD6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UlDAvpasnM4s4W+Sq+pSrHOgjc7qZPKK+ns8CWB87DViarSteNkYuIRiB1uVtglLBK
         yWYhTRSsM3G0qCKxm+OOcYlX8Vt35uVb1+49G61IBa9L4N48P4xBK/dWL10Ei160ebXP
         b1GWPxStd5zYqsXblWXEJOPBBgDjo/ifkRr50=
Date: Mon, 6 Sep 2010 20:58:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3] scsi_debug: Convert to use root_device_register() and
 root_device_unregister()
Message-ID: <20100907035803.GA1562@core.coreip.homeip.net>
References: <1283819068-24587-1-git-send-email-nab@linux-iscsi.org>
 <20100907003251.GA21430@core.coreip.homeip.net>
 <1283828456.15944.1323.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283828456.15944.1323.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:00:56PM -0400, James Bottomley wrote:
> On Mon, 2010-09-06 at 17:32 -0700, Dmitry Torokhov wrote:
> > On Mon, Sep 06, 2010 at 05:24:28PM -0700, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Hi Doug and Co,
> > > 
> > > This patch updates the scsi_debug virtual LLD to use root_device_register()
> > > and root_device_unregister() from include/linux/device.h instead of device_register()
> > > and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> > > This simply involved converting the static struct device pseudo_primary into a
> > > pointer that is setup by the call to root_device_register().
> > > 
> > > This patch also contains the correct IS_ERR() conditional check of
> > > root_device_register() from within scsi_debug_init().
> > > 
> > > Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> > > 
> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > 
> > Thanks for making the changes.
> > 
> > Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Can I make that Reviewed-by:? Acked-by is really just for maintainer
> patches which don't warrant a signoff.
> 

Sure, whatever suits better.

-- 
Dmitry
