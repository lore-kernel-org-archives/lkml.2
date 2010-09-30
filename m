Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0I3Rqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:46:51 -0400
Received: from dspnet.fr ([188.165.44.67]:57195 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0I3Rqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:46:50 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 13:46:49 EDT
Date: Thu, 30 Sep 2010 19:35:47 +0200
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: [PATCH] Fix capi devicenames
Message-ID: <20100930173547.GA91193@dspnet.fr>
References: <4CA391B3.1030806@wol.de>
 <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
 <1285843077.748.32.camel@marc>
 <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk>
 <1285851024.748.97.camel@marc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285851024.748.97.camel@marc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 02:50:24PM +0200, Marc - A. Dahlhaus wrote:
[...]
> The only setup that could get broken by this is the setup that uses udev
> to handle the devices and gives the nodes different access rights or
> something.
> 
> And that already happened by the time the rules used to create the capi
> devices got removed from udev and it was right to remove them from udev
> IMO.
[...]
> capifs is already deprecated and scheduled for removal soon because udev
> is able to replace its functionality and fedora has a patch in srpm that
> removes the capifs load from capiinit.
> 
> Userspace expects the capifs device nodes.
[...]

So if I understand correctly, capifs was deprecated and is soon be
removed because udev was able to replace it given a set of rules, then
after the deprecation was done the rules were deliberately removed
from udev.  And that's supposed to be a kernel issue?

Sounds... typical, actually.

  OG.
