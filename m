Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1CVW1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:27:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1CVW07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:26:59 -0400
Date: Tue, 22 Mar 2011 15:22:59 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Oren Weil <oren.jer.weil@intel.com>,
        linux-kernel@vger.kernel.org, david@woodhou.se
Subject: Re: [PATCH 1/7] char/mei: PCI device and char driver support.
Message-ID: <20110322222259.GA26362@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
 <1300791092-14319-2-git-send-email-oren.jer.weil@intel.com>
 <201103221822.43780.arnd@arndb.de>
 <20110322215759.2d982e06@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322215759.2d982e06@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:57:59PM +0000, Alan Cox wrote:
> > * In the PCI probe function, create a misc character device for
> >   every instance you find behind each device. Remove the global
> >   variables and constants.
> 
> The current code is complex and could be a ton simpler *but* don't
> abuse misc devices when you have one per PCI instance please.

The code specifically says it only supports one device in the system at
a time.  Since it can't do any more than that, why wouldn't it be
correct for a misdevice to be used here?

thanks,

greg k-h
