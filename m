Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1GSNqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:46:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1GSNqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:46:47 -0400
Date: Tue, 19 Jul 2011 15:46:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/34] System Firmware Interface
Message-ID: <20110719134645.GI8006@one.firstfloor.org>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk> <20110719132157.GG8006@one.firstfloor.org> <4E25892C.8070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E25892C.8070102@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 09:39:56AM -0400, Prarit Bhargava wrote:
> 
> The DMI specification has not been updated since January of 2003.  It
> has been replaced by SMBIOS.


Yes of course, but dmidecode and the current DMI layer implements
both anyways, don't they? (ok if you don't count the dynamic interfaces)

The tables are very similar, there are just more entries in SMBIOS.

> 
> >> 3.	Every other platform without DMI would benefit from the
> >> 	interface being generic
> >>     
> > Can you expand on that? The information will be always system
> > specific anyways. Do you really think there's that much commonality?
> >
> >   
> 
> There seems to be some commonalities.  We have other arches checking for
> model and vendor info.

That's two fields out of hundreds. Does that need a common layer?

Right now I still fail to see the point of all of this.

At some point I wanted a slightly more expansive sysfs interface for SMBIOS
to avoid having to start mcelog as root for reading /dev/mem, but I don't
think such a complicated approach is justified for that. What are 
the other use cases?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
