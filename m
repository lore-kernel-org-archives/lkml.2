Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1AGAdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:33:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1AGAdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:33:02 -0500
Date: Thu, 6 Jan 2011 16:31:59 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, "'Randy Dunlap'" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 22/36] serial: fix pch_uart kconfig & build
Message-ID: <20110107003159.GA3871@suse.de>
References: <20110106215404.GA30624@kroah.com>
 <1294352605-31906-22-git-send-email-gregkh@suse.de>
 <8899E5C010CA4DECA82313385205780B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8899E5C010CA4DECA82313385205780B@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 09:21:43AM +0900, Tomoya MORINAGA wrote:
> Hi Greg,
> 
> On Friday, January 07, 2011 7:23 AM, Greg Kroah-Hartman wrote:
> > Also, the help text says that the 
> > driver enables & uses PCH_DMA, which is not enabled, so select that. 
> 
> I think PCH_DMA is not always used when a user uses PCH_UART.
> Since overhead of DMA is not small, in case of low frequent communication,
> without DMA is better.
> Thus, I think "select PCH_DMA" is unnecessary
> 
> (Of course, the PCH_UART works both with/without PCH_DMA.)

Patches are always welcome to fix things up :)

thanks,

greg k-h
