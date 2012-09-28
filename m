Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423204Ab2I1VG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:06:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43588 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965319Ab2I1VGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:06:08 -0400
X-Sasl-enc: PIgoZOn+DiFE/+ElpyJvqhY9enfanBNUUEglPrsbLl77 1348866367
Date: Fri, 28 Sep 2012 14:05:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <chris.mason@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ 173/262] mutex: Place lock in contended state after
 fastpath_lock failure
Message-ID: <20120928210541.GC25749@kroah.com>
References: <20120928182957.993484211@linuxfoundation.org>
 <20120928183018.432178544@linuxfoundation.org>
 <alpine.LFD.2.02.1209281522360.6667@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209281522360.6667@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:26:40PM -0400, Nicolas Pitre wrote:
> On Fri, 28 Sep 2012, Greg Kroah-Hartman wrote:
> 
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit 0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1 upstream.
> 
> Now that you've queued this one, could you pick up a76d7bd96d as well 
> please?

Sure, for just 3.5.y or any other stable trees?

thanks,

greg k-h
