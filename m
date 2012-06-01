Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064Ab2FAPzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:55:48 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60199 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2FAPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:55:43 -0400
Date: Fri, 1 Jun 2012 14:58:31 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 12/94] net/wireless: ipw2200: Fix WARN_ON occurring in
 wiphy_register called by ipw_pci_probe
Message-ID: <20120601065831.GA13229@kroah.com>
References: <20120527010332.GA11170@kroah.com>
 <20120527010425.489792331@linuxfoundation.org>
 <20120527194743.GB2638@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527194743.GB2638@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 04:47:44PM -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, May 27, 2012 at 10:04:35AM +0900, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> 
> Same as what I commented on this being proposed for 3.4.y, this would
> only be needed if "ipw2200: Fix order of device registration" was
> applied to 3.3 kernels.

Thanks, I've now removed this patch from both the 3.4 and 3.3 queues.

greg k-h
