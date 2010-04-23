Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab0DWQIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:08:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab0DWQIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:08:09 -0400
Date: Fri, 23 Apr 2010 09:02:27 -0700
From: Greg KH <gregkh@suse.de>
To: Evan McClain <evan.mcclain@gatech.edu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [051/197] backlight: mbp_nvidia_bl - add five more MacBook
 variants
Message-ID: <20100423160227.GB8048@suse.de>
References: <20100422191857.GA13268@kroah.com>
 <20100422190911.935042749@kvm.kroah.org>
 <20100422195413.GA10849@macbook.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422195413.GA10849@macbook.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 03:54:13PM -0400, Evan McClain wrote:
> On Thu, Apr 22, 2010 at 12:08:22PM -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Apparently the MacBook1,1 reports the manufacturer as Apple Computer, Inc.
> 
> A patch was submitted here: http://lkml.org/lkml/2010/3/23/412
> 
> Steffen Röcker wasn't sure about the MacBook2,1 but according to sample
> dmidecode outputs:
> http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg07914.html
> and
> http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg09304.html
> for MacBook1,1 and MacBook2,1 systems respectively, MacBook2,1 reports
> as Apple Inc. as in my original patch.
> 
> Sorry for not catching this earlier.

I don't understand, is this patch not correct?  Should I drop it from
the stable release?

thanks,

greg k-h
