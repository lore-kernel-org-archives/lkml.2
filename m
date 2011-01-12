Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab1ALDIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 22:08:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1ALDIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 22:08:35 -0500
Date: Tue, 11 Jan 2011 19:04:02 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_phub: add new device ML7213
Message-ID: <20110112030402.GA6884@suse.de>
References: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20101222044424.GC19006@suse.de>
 <9E719661EAC44CEBAE5E5E0ABD51B4E0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E719661EAC44CEBAE5E5E0ABD51B4E0@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:59:35AM +0900, Tomoya MORINAGA wrote:
> Hi Greg,
> 
> On Wednesday, December 22, 2010 1:44 PM, Greg KH wrote:
> > Put the device type here in the device table, so you don't 
> > have to check for it again in the probe function.  That way 
> > you can save some code and keep things simpler and more 
> > obvious in the future when adding new device ids, that you 
> > also have to pick the type for it.
> 
> Have you reviewed our "v2 patch" which is modified for the above?

It is in my "to apply" queue.  The hollidays here kept me from working
on kernel things for 2 weeks, and now the merge window is happening, but
after .38-rc1 is out, I will get to the patch.

thanks for your patience,

greg k-h
