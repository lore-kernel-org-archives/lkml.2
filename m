Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2GQQFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:05:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55660 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2GQQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:05:09 -0400
Date: Tue, 17 Jul 2012 09:05:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address
 injection
Message-ID: <20120717160505.GB20481@kroah.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-2-git-send-email-kys@microsoft.com>
 <20120717040912.GA6369@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717040912.GA6369@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 06:09:13AM +0200, Olaf Hering wrote:
> On Sat, Jul 14, K. Y. Srinivasan wrote:
> 
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > index 68ed7f7..38b561a 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -127,6 +127,8 @@ enum hv_kvp_exchg_op {
> >  	KVP_OP_SET,
> >  	KVP_OP_DELETE,
> >  	KVP_OP_ENUMERATE,
> > +	KVP_OP_GET_IP_INFO,
> > +	KVP_OP_SET_IP_INFO,
> >  	KVP_OP_REGISTER,
> >  	KVP_OP_COUNT /* Number of operations, must be last. */
> >  };
> 
> I think this will break the kernel/daemon API for existing binaries.

I know it will break :)

KY, you can't break the existing user/kernel api that you created a few
kernel versions ago, sorry.  Please fix this, we can not take this
as-is, nor should you want us to.

thanks,

greg k-h
