Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0GERs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:48:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34833 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0GERs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:48:27 -0400
Date: Mon, 5 Jul 2010 18:48:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Martin Filip <bugtraq@smoula.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Macbook Pro 5,5 nvidia backlight fix
Message-ID: <20100705174823.GA16764@srcf.ucam.org>
References: <4C31F9C4.8090609@smoula.net> <20100705172552.GA16298@srcf.ucam.org> <4C321A0D.20008@smoula.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C321A0D.20008@smoula.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 07:44:45PM +0200, Martin Filip wrote:
> On 5.7.2010 19:25, Matthew Garrett wrote:
> > On Mon, Jul 05, 2010 at 05:27:00PM +0200, Martin Filip wrote:
> >> Maybe someone involved with this module can merge this one?
> > 
> > This is a really bad idea. You're hardcoding the location of PDISPLAY, 
> > which the kernel is at liberty to remap at boot time, and even then 
> > you're writing into the address space of a device that's controlled by 
> > another driver.
> well, I understand what you do not like. But I'm not capable of fixing
> this. Let's say I'm just reporting something that does not work and
> pointing out, that "this way it works for me for almost a year on
> different versions of kernel". Is there someone, who understands that?

Yes, which is why I added support for it to nouveau...

> > Does nouveau not handle this hardware properly?
> I'm user of nvidia binary drivers. I can try, but I doubt.

The graphics hardware is supposed to be under the control of the 
graphics driver. If your graphics driver is deficient then you'll really 
have to take that up with your vendor.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
