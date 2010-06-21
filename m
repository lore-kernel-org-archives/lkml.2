Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab0FUUcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:32:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FUUcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:32:10 -0400
Date: Mon, 21 Jun 2010 13:27:19 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
Message-ID: <20100621202719.GA24796@suse.de>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-13-git-send-email-tj@kernel.org>
 <4C1F6E5D.5030809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F6E5D.5030809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:51:25PM +0200, Tejun Heo wrote:
> On 06/13/2010 05:31 PM, Tejun Heo wrote:
> > Ask IRQ subsystem to watch HCD IRQ line after initialization.  This at
> > least keeps USB ports which are occupied on initialization working and
> > eases bug reporting and debugging.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Greg, if you think the change is okay, can you please ack it?  Also,
> would it be okay to route this through irq tree?

Sorry, I thought I did earlier.  Yes, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
and take it through what ever tree you want to :)

thanks,

greg k-h
