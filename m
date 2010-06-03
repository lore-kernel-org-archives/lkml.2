Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0FCQcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:32:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab0FCQck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:32:40 -0400
Date: Thu, 3 Jun 2010 09:26:55 -0700
From: Greg KH <gregkh@suse.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Message-ID: <20100603162655.GA6728@suse.de>
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
 <20100603115727.GY2695@buzzloop.caiaq.de>
 <201006031221.56150.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006031221.56150.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:21:56PM -0400, Gene Heskett wrote:
> How soon can this get in?  I ask because I have been crippled in all 
> attempts to use an ftdi adaptor to talk to an old legacy machine I have for 
> about that long now. xon/xoff seems completely broken, and 7wire seems to 
> scramble things to the point where no null modem cable I have made (and I 
> have a book on them) will allow the 7wire flow controls to function.

Give it a week or so to get out to all the stable kernel releases.

thanks,

greg k-h
