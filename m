Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab0EGVXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:23:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab0EGVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:23:10 -0400
Date: Fri, 7 May 2010 14:21:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <20100507211331.GA28906@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005071418200.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <20100507061203.GA8779@srcf.ucam.org> <alpine.LFD.2.00.1005071402080.901@i5.linux-foundation.org>
 <20100507211331.GA28906@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 May 2010, Matthew Garrett wrote:

> On Fri, May 07, 2010 at 02:06:53PM -0700, Linus Torvalds wrote:
> > On Fri, 7 May 2010, Matthew Garrett wrote:
> > > 
> > > The spec says we can't. I've posted a patch to do so if it's still not 
> > > set after we've tried doing it the right way, but I'm not keen on 
> > > pushing it into a release at this point.
> > 
> > I'm ok with the "release at this point".
> 
> http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=3b12303e6bda6e05579d899fb71cb3e9d3bc26ba

Well, is there any reason to have 'set_sci_en_on_resume' at all then?

I mean, the only reason for that config thing in the first place is that 
we didn't do this from the beginning. No?

And I'd hate to then carry the DMI table along forever just to set a 
variable that isn't worth setting any more..

IOW, I don't disagree with the patch. I just don't think it went far 
enough.

		Linus


