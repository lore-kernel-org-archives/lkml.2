Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0FNWRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:17:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0FNWRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:17:18 -0400
Date: Mon, 14 Jun 2010 15:11:24 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
Message-ID: <20100614221124.GA22801@suse.de>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-13-git-send-email-tj@kernel.org>
 <20100614214122.GA21064@suse.de>
 <4C16A48A.2070404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C16A48A.2070404@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:52:10PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/14/2010 11:41 PM, Greg KH wrote:
> > So if there's a routing problem, it turns into a polled interrupt?  Do
> > we really want that?
> 
> Oh yeah, I really want that for libata.  Routing is only part of the
> problem and flaky IRQ is something we have to learn to cope with.
> 
> > I wonder how long people will run without realizing that there are
> > problems with their system if their devices still work.
> 
> I think things would be better this way.  If the drives (both cd and
> hard) / input devices are not accessible, most people would simply
> give up rather than reporting, and many cases are transient problems
> which happen only once in the blue moon.
> 
> It would be great if some kind of automatic reporting can be used
> (similar to kerneloops?).  Hmm... maybe make the warnings scarier?

If you throw a WARN(), then kerneloops will pick it up, so you should be
fine there.

thanks,

greg k-h
