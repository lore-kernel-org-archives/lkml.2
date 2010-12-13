Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0LMWY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:24:29 -0500
Received: from kroah.org ([198.145.64.141]:57407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0LMWY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:24:27 -0500
Date: Mon, 13 Dec 2010 14:17:49 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213221749.GA22029@kroah.com>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
 <20101213183032.GA6147@kroah.com>
 <20101213202429.GA6811@bart.evergreen.loc>
 <20101213211531.GA19783@kroah.com>
 <1292277192.26970.65.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292277192.26970.65.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:53:12PM -0800, Joe Perches wrote:
> On Mon, 2010-12-13 at 13:15 -0800, Greg KH wrote:
> > On Mon, Dec 13, 2010 at 09:24:30PM +0100, L. Alberto Giménez wrote:
> > > +#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
> > > Recommended by Joe. I agree that it is cleaner and more compliant.
> > Not really, it should be replaced with dev_err() or some such universal
> > replacement.
> 
> It's used with and without access to a struct device.
> 
> The uses that have a struct device available should be
> dev_<foo> and with a struct net_device should be netdev_<foo>
> though that's a wider change.
> 
> It's also used in consecutive calls without newline where
> KERN_CONT should be used instead.
>  
> Greg, you replied to the list but not the sender.
> Please don't drop the sender.

If you look at the original message I responded to, the sender asked
_not_ to be included based on the headers of the message, so my email
client did the correct thing.
