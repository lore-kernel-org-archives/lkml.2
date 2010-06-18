Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0FRCmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:42:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:56771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0FRCma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:42:30 -0400
Date: Thu, 17 Jun 2010 19:37:58 -0700
From: Greg KH <gregkh@suse.de>
To: DDD <dongdong.deng@windriver.com>
Cc: Greg KH <greg@kroah.com>, jason.wessel@windriver.com,
       galak@kernel.crashing.org, bruce.ashfield@windriver.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: cpm_uart: implement the cpm_uart_early_write()
 function for console poll
Message-ID: <20100618023758.GA10393@suse.de>
References: <1276744420-7845-1-git-send-email-dongdong.deng@windriver.com>
 <20100617173101.GB24362@kroah.com>
 <4C1AD5A8.1030203@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1AD5A8.1030203@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 10:10:48AM +0800, DDD wrote:
> Greg KH wrote:
> >On Thu, Jun 17, 2010 at 11:13:40AM +0800, Dongdong Deng wrote:
> >>The cpm_uart_early_write() function which was used for console poll
> >>isn't implemented in the cpm uart driver.
> >>
> >>Implementing this function both fixes the build and allows
> >>kgdboc to work via the cpm uart.
> >
> >So this is needed for the .35 release, right?  Any older kernel releases
> >as well?
> 
> Yes, it is needed for the .35 release.
> 
> The cpm_uart_early_write() of cpm_uart was introduced at 2.6.27,
> so this patch is needed from 2.6.27.

So no one has noticed that the driver doesn't build at all since the .27
kernel release?  Over 2 years?  I hardly think that it's a rush to fix
it over the next few weeks then :)

I'll go queue it up.

thanks,

greg k-h
