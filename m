Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1CAXyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:54:44 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:59664 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059Ab1CAXym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:54:42 -0500
Date: Tue, 1 Mar 2011 18:54:33 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: dj@deadhat.com, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Why is my copyright code in the linux kernel?
Message-ID: <20110301235433.GD2959@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	dj@deadhat.com, linux-kernel@vger.kernel.org, gregkh@suse.de
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
 <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:30:45AM +0100, richard -rw- weinberger wrote:
> > You will see a remarkable resemblance to parts of
> > linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,
> 
> please note, this is a staging driver.

It's not even the primary driver.  Is there anything that this driver
provides that isn't provided by the upstream supported, mainline
rt2x00 project?  I.e., can we just delete the staging driver?

If we are going to keep the staging driver for some reason, one of the
things that should be added to the TODO list would be delete its
driver-specific AES code and replace it with calls to the kernel's
generic AES code, which among other things, has the advantage that it
can take advantage of the AES-NI instructions provided on more modern
x86 CPU's.

> > I'd like to know who is an appropriate person to discuss this with.
> 
> the code is from ralink.

David, you might want to contact ralink directly, since it's likely
they are distributing that driver with your AES code in other places
besides just in the mainstream kernel sources.  Even if we delete the
code in the staging tree, they might be distributing that driver still
via other means.

Regards,

						- Ted
