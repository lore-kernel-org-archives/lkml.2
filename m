Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0ELOy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:54:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49874 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750976Ab0ELOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:54:24 -0400
Date: Wed, 12 May 2010 10:54:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Joe Perches <joe@perches.com>, USB list <linux-usb@vger.kernel.org>,
       <alsa-devel@alsa-project.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of start_frame in usbusx2yaudio.c
In-Reply-To: <20100512051058.GA32459@xanatos>
Message-ID: <Pine.LNX.4.44L0.1005121051040.1962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Sarah Sharp wrote:

> Are there any drivers in the kernel that set urb->start_frame on every
> URB?
> 
> Could those drivers handle it if only the first URB they submitted to
> the host controller was scheduled for that frame ID, and all the rest of
> the URBs were scheduled ASAP?

BTW, urb->start_frame generally is ignored as an input parameter.  Many 
host controller drivers pay no attention to it.  Unless someone has a 
real reason, I think we are better off not using it.

Alan Stern

