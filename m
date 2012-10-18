Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2JRVCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:02:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2JRVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:02:43 -0400
Date: Thu, 18 Oct 2012 14:02:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: Remove unnecessary __used
Message-ID: <20121018210236.GA31498@kroah.com>
References: <1350587223.5652.4.camel@joe-AO722>
 <20121018192007.GB3703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018192007.GB3703@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:20:08PM -0400, Jason Baron wrote:
> On Thu, Oct 18, 2012 at 12:07:03PM -0700, Joe Perches wrote:
> > The __used attribute prevents gcc from eliminating
> > unnecessary, otherwise optimized away, metadata for
> > debugging logging messages.
> > 
> > Remove the __used attribute.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  include/linux/dynamic_debug.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> > index c18257b..6dd4787 100644
> > --- a/include/linux/dynamic_debug.h
> > +++ b/include/linux/dynamic_debug.h
> > @@ -61,7 +61,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
> >  			 const char *fmt, ...);
> >  
> >  #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > -	static struct _ddebug __used __aligned(8)		\
> > +	static struct _ddebug  __aligned(8)			\
> >  	__attribute__((section("__verbose"))) name = {		\
> >  		.modname = KBUILD_MODNAME,			\
> >  		.function = __func__,				\
> > 
> > 
> 
> Greg, Pls pull this.

I will, thanks.

greg "here, have a vowel or three" k-h
