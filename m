Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0ENQ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:29:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61450 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0ENQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ObaSlJF4mkJo/W1MNIpUFTLTuOcaQ+Kd7nfkvoK2EtBCclwaXV+Q4KdYkAgYPsByFu
         Rx176oSPkMYzDcWpx15tiarr4YEoh6uOtOgMAEUpdFsqp7QfLxQtkqpo23nahWlGCeti
         HUiRi1xuvllksyV0jS1i8gUGU9uLvjZjXGBYs=
Date: Fri, 14 May 2010 09:28:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100514162858.GA31607@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100514145539.GA5598@srcf.ucam.org>
 <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 08:16:34AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 14 May 2010, Matthew Garrett wrote:
> >
> > I've done some experimentation under qemu. On ACPI systems, Windows will 
> > *only* touch the keyboard controller if there's a device with an 
> > appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> > Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> > their keyboard probing is also somewhat different to ours, but that's 
> > probably another story.
> 
> Well, I'd hate to lose the keyboard hotplug capability, but at the same 
> time, it _is_ 2010, and while I have personally used it historically, I 
> don't really foresee ever using it again.
> 

FWIW we also using active multiplexing while windows does not as far as
I know. I'd like us to be better than them.

> So we _could_ decide to just try it, and see if anybody screams. If nobody 
> does, that would be a very simple solution to the problem.
> 
> 			Linus

-- 
Dmitry
