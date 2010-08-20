Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0HTTH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:07:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0HTTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:07:25 -0400
Date: Fri, 20 Aug 2010 12:07:19 -0700
From: Greg KH <gregkh@suse.de>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 oopses at boot time in kobject allocation
Message-ID: <20100820190719.GA8804@suse.de>
References: <4C6D9289.4000702@cs.cmu.edu>
 <20100819203435.GA28508@suse.de>
 <4C6E799A.7060902@cs.cmu.edu>
 <AANLkTikkiD7qfHqkMSq3id=ap6V6gvsddca+tc8Q+bk0@mail.gmail.com>
 <4C6ED15E.3050506@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6ED15E.3050506@cs.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 03:02:54PM -0400, Benjamin Gilbert wrote:
> Ming Lei wrote:
> >2010/8/20 Benjamin Gilbert <bgilbert@cs.cmu.edu>:
> >>commit f8a4bd3456b988fc73b2c291b9e01b434c8fa940
> >>Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >>Date:   Fri Jun 4 00:54:43 2010 -0700
> >>
> >>   firmware loader: embed device into firmware_priv structure
> >
> >This commit does introduce one possible double free, maybe is related with
> >the issue, please try the attachment patch to see if the oops can be fixed.
> 
> The patch fixes it for me.  Thanks.

Great, it's in my queue to go to Linus in a day or so.

thanks for testing.

greg k-h
