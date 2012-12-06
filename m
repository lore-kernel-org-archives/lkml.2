Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2LFAZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:25:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LFAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:25:33 -0500
Date: Wed, 5 Dec 2012 16:25:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, ltsi-dev@lists.linuxfoundation.org
Subject: Re: LTSI 3.4.21-rc1 kernel now released
Message-ID: <20121206002530.GC17646@kroah.com>
References: <20121206002328.GA17646@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206002328.GA17646@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:23:28PM -0800, Greg KH wrote:
> Hi all,
> 
> I'd like to announce the LTSI 3.4.21-rc1 kernel.  It's a first cut at
> the patches that have been submitted to be included in the LTSI 3.4
> kernel branch.  I've tested it out on my machine, but it really needs
> testing from those who want to be running the LTSI kernel series.
> 
> The diffstat for the patch is below, but the highlights of it are:
> 	- AF_BUS patches
> 	- LTTng
> 	- pramfs (but disabled due to build problems)
> 	- azfs (also disabled due to build problems)
> 	- Board support for Armadillo 800, AT91, kzm9d, kzm9g, and
> 	  Marzen platforms.

Oops, I forgot the big dma-mapping patches that are also included here,
lots of people were wanting them, many thanks to Damian Hobson-Garcia
for doing the hard work of backporting all of them and merging them
properly to get it to work well.

thanks,

greg k-h
