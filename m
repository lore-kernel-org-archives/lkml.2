Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1HOOkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:40:32 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5725 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1HOOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:40:29 -0400
Date: Mon, 15 Aug 2011 09:40:22 -0500
From: scameron@beardog.cce.hp.com
To: Greg KH <greg@kroah.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: add heartbeat sysfs host attribute
Message-ID: <20110815144022.GR27723@beardog.cce.hp.com>
References: <20110812180314.21808.59261.stgit@beardog.cce.hp.com> <20110813020147.GB15554@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813020147.GB15554@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 07:01:47PM -0700, Greg KH wrote:
> On Fri, Aug 12, 2011 at 01:03:14PM -0500, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > The cciss driver had a CCISS_HEARTBEAT ioctl which
[...]
> >  
> > +  The "heartbeat" read-only attribute returns the value of a heartbeat
> > +  counter register on a Smart Array controller as a 32 bit unsigned
> > +  hexadecimal integer (e.g: "0x12345678").  The value should change
> > +  periodically, not less than once per second.  If this value fails to
> > +  change for a period longer than one second, it means something has
> > +  gone wrong (e.g. Smart Array controller firmware has locked up.)
> > +
> 
> This all belongs in Documentation/ABI/ care to move it there instead?

Sure.

-- steve

