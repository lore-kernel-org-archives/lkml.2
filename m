Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1EJUI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:08:28 -0400
Received: from kroah.org ([198.145.64.141]:45332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1EJUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:08:27 -0400
Date: Tue, 10 May 2011 13:01:54 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110510200154.GA12044@kroah.com>
References: <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
 <20110503213925.GA7453@opensource.wolfsonmicro.com>
 <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
 <20110503220233.GB14080@kroah.com>
 <20110503222635.GA8035@opensource.wolfsonmicro.com>
 <20110503223237.GA25039@kroah.com>
 <20110503235917.0493fd0d@lxorguk.ukuu.org.uk>
 <20110503230630.GA26903@kroah.com>
 <20110504085753.GB9254@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504085753.GB9254@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 09:57:53AM +0100, Mark Brown wrote:
> On Tue, May 03, 2011 at 04:06:30PM -0700, Greg KH wrote:
> > On Tue, May 03, 2011 at 11:59:17PM +0100, Alan Cox wrote:
> 
> > > Best bet is to apply Mark's patch into your git tree then apply mine on
> > > top I think. Git will see the same patch in both trees and resolve it all
> > > nicely for -next.
> 
> > Have a pointer to which patch that was?
> 
> It's 774fd7 (sst: fix compile error) which is in -next.

That's one of the, I needed another as well :)

Anyway, I've queued all of these up now so hopefully we should all be in
sync correctly.

thanks,

greg k-h
