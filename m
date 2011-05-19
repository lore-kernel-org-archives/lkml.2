Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1ESQCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:02:55 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36476 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab1ESQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:02:54 -0400
X-Sasl-enc: s6c56tMvCw2f1FbCdnKtduvoWgUcQM/rp5zNtfj+w69F 1305820973
Date: Thu, 19 May 2011 09:02:39 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kumar.gala@freescale.com,
        benh@kernel.crashing.org, akpm@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
Message-ID: <20110519160239.GB25606@kroah.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
 <1305813272-31826-7-git-send-email-timur@freescale.com>
 <20110519153358.5876f310@lxorguk.ukuu.org.uk>
 <4DD533DE.1020705@freescale.com>
 <20110519165039.7fd8ec34@lxorguk.ukuu.org.uk>
 <4DD53D1B.4060600@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD53D1B.4060600@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:54:03AM -0500, Timur Tabi wrote:
> > Depends if the functionality is useful in your environment or not
> 
> It is, but I'd like to add it later so that I can make the 2.6.40 window (if it
> isn't already too late).

It's too late, it needed to be in linux-next _before_ the window opened.

sorry,

greg k-h
