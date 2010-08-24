Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0HXUNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:13:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:37264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab0HXUNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:13:42 -0400
Date: Tue, 24 Aug 2010 13:13:36 -0700
From: Greg KH <gregkh@suse.de>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100824201336.GA16671@suse.de>
References: <1275175983.2122.42.camel@itpsd6lap>
 <1276123020.16010.97.camel@itpsd6lap>
 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
 <1276291932.2154.45.camel@itpsd6lap>
 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
 <1277244410.2195.47.camel@itpsd6lap>
 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
 <1277462596.2143.101.camel@itpsd6lap>
 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
 <1282680194.8020.46.camel@itpsd6lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282680194.8020.46.camel@itpsd6lap>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:03:13PM +0200, Samo Pogacnik wrote:
> On 25.06.2010 (Fri) at 12:03 +0100 Alan Cox wrote: 
> > With my devices.txt owner hat on I'll allocate the minor as you suggest
> > (and double check this causes no problems), with my tty hat on can you
> > send it to GregKH for merging into the tree.
> 
> Hi,
> 
> I hope that this TTY driver is ok for merging. It is very basic -
> removed all flow control and rate limiting. Patch has been generated
> against 2.6.34 kernel version.
> 
> regards, Samo
> ---
> Signed-off-by: Samo Pogacnik <samo_pogacnik@t-2.net>

I need some information on what this patch is, and why we would want it,
so that it can be put into the changelog.  Care to resend it with that
information present?

thanks,

greg k-h
