Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433Ab2KBRUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760613Ab2KBRUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:20:33 -0400
Date: Fri, 2 Nov 2012 13:19:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102171952.GK3300@redhat.com>
References: <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
 <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 01:50:08PM -0400, Eric Paris wrote:

[..]
> I've talked with and
> worked with a public cloud operator who wants to prevent even a
> malicious root user from being able to run code in ring 0 inside their
> VM.  The hope in that case was that in doing so they can indirectly
> shrink the attack surface between virtual machine and hypervisor.
> They hoped to limit the ways the guest could interact to only those
> methods the linux kernel implemented.
> 
> They want to launch a vm running a kernel they chose and make sure
> root inside the vm could not run some other kernel or run arbitrary
> code in kernel space.  It's wasn't something they solved completely.
> If it was, all of this secure boot work would be finished.  Which is
> why we are having these discussions to understand all of the way that
> you an Alan seem to have to get around the secure boot restrictions.
> And look for solutions to retain functionality which meeting the
> security goal of 'prevent uid=0 to ring 0 privilege escalation.

So will secure boot help with above use case you mentioned? I think
until and unless you lock down user space too on host, it will not be
possible.

On the flip side, one might be able to launch windows in qemu (compromised
noe) and might fool user into thinking it is booted natively and steal
login credentials and other stuff.

Thanks
Vivek
