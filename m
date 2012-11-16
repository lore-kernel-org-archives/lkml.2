Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2KPTEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:04:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50325 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2KPTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:04:10 -0500
Date: Fri, 16 Nov 2012 11:04:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        jens.taprogge@taprogge.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH] ipack: move header files to include/linux
Message-ID: <20121116190406.GA18986@kroah.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
 <1353089331.2512.2.camel@joe-AO722>
 <1353089655.4563.56.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353089655.4563.56.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:14:15PM +0100, Samuel Iglesias Gonsálvez wrote:
> On Fri, 2012-11-16 at 10:08 -0800, Joe Perches wrote:
> > On Fri, 2012-11-16 at 18:34 +0100, Samuel Iglesias Gonsalvez wrote:
> > > Move ipack header files to include/linux/ directory where they belong to.
> > 
> > Why do these belong in include/linux?
> 
> They are used for other drivers that could be in other directories.
> 
> > What's wrong with path relative includes?
> 
> There is nothing wrong with relative includes. It's just to do the
> things as other subsystems do: keeping the bus' header file in
> include/linux directory.
> 
> Is this approach wrong for this case?

No, not at all, this is fine.

thanks,

greg k-h
