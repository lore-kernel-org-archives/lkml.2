Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1C1Ocl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:32:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:35691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab1C1Ock (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:32:40 -0400
Date: Mon, 28 Mar 2011 07:21:48 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Hardy <shardy@redhat.com>
Cc: mjg@redhat.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Fix memory leak in qcserial driver
Message-ID: <20110328142148.GA19521@suse.de>
References: <1301321186.4397.13.camel@shardy.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301321186.4397.13.camel@shardy.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 03:06:26PM +0100, Steven Hardy wrote:
> Hi,
> 
> I've been experimenting with kmemleak and noticed a recurring leak warning whenever I load & unload the qcserial driver.
> 
> Inspection of the code seems to indicate the leak is the serial->private data allocated in the qcprobe() function, 
> which is never freed (apart from in some of the qcprobe error paths) as far as I can tell.
> 
> The patch below fixes the following problems:

<snip>

Can you fix your email client to properly wrap your lines?

Also, as you do 3 different things here, can you break this into 3
patches and resend them?

thanks,

greg k-h
