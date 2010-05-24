Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0EXSn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:43:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0EXSn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:43:57 -0400
Date: Mon, 24 May 2010 11:41:29 -0700
From: Greg KH <gregkh@suse.de>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, Alexander Kurz <linux@blala.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers
 grouped by bustype.
Message-ID: <20100524184129.GC8291@suse.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de>
 <20100514190142.GA2505@kroah.com>
 <4BFA4F52.1090004@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA4F52.1090004@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:05:06AM +0100, Martyn Welch wrote:
> Even if there are a few dependencies missing, it seems like a step forward.

Yes it is, that's why it is now in Linus's tree for inclusion in the .35
release :)

thanks,

greg k-h
