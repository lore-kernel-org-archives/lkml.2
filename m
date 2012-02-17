Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2BQCh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:37:56 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58632 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab2BQChz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:37:55 -0500
X-Sasl-enc: nCK27B9bQOHUHvcULJ53XsDWTunk2TOmx83dBWJz/ZwU 1329446274
Date: Thu, 16 Feb 2012 18:37:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [21/28] crypto: sha512 - Avoid stack bloat on i386
Message-ID: <20120217023742.GA21909@kroah.com>
References: <20120217005609.GA17081@kroah.com>
 <20120217005536.880797019@linuxfoundation.org>
 <20120216.205231.945122823725765709.davem@davemloft.net>
 <20120217021718.GA21573@kroah.com>
 <20120217022806.GA4980@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217022806.GA4980@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 01:28:06PM +1100, Herbert Xu wrote:
> On Thu, Feb 16, 2012 at 06:17:18PM -0800, Greg KH wrote:
> > On Thu, Feb 16, 2012 at 08:52:31PM -0500, David Miller wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Date: Thu, 16 Feb 2012 16:55:55 -0800
> > > 
> > > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > This causes a stack usage regression on sparc that Herbert
> > > is in the middle of merging a fix for into Linus's tree.
> > 
> > Ick.  Any idea when that will hit Linus's tree?  If it's before next
> > Monday, we are good, and I can queue it up here, if not, then I'll drop
> > this and have to add it back later.
> 
> I've pushed it though it hasn't been pulled yet:
> 
> The commit ID is f2ea0f5f04c97b48c88edccba52b0682fbe45087.

Thanks, I'll watch out for it.

greg k-h
