Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2CHRdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:33:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48496 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2CHRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:33:48 -0500
Date: Thu, 8 Mar 2012 09:33:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 05/11] android: ram_console: split out persistent ram
Message-ID: <20120308173343.GB4456@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
 <1331170478-30538-6-git-send-email-john.stultz@linaro.org>
 <20120308024203.GA25842@kroah.com>
 <1331179148.2191.261.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331179148.2191.261.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:59:08PM -0800, John Stultz wrote:
> On Wed, 2012-03-07 at 18:42 -0800, Greg KH wrote:
> > Because of this, sorry, I can't take the rest of these patches in this
> > series.  If the 10th or 11th ones are needed, care to refresh it against
> > my tree and resend it so that I can take it?
> 
> 10/11 depends on the patches you didn't take, so it gets dropped as
> well.
> 
> 11/11 should still apply, and shouldn't need to be refreshed. 

It applied with a ton of fuzz, so I wasn't sure about it.

> Would you mind applying it, or do you really want it send it on its
> own? 

I'll go queue up all of these now that I understand pstore is the goal
here.  That's what I was worried about.

thanks,

greg k-h
