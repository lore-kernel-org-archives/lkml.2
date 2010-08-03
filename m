Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0HCPPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:15:46 -0400
Received: from kroah.org ([198.145.64.141]:60891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab0HCPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:15:45 -0400
Date: Tue, 3 Aug 2010 08:14:45 -0700
From: Greg KH <greg@kroah.com>
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be
 fully populated"
Message-ID: <20100803151445.GD31368@kroah.com>
References: <4BFB947E.9080509@aixigo.de>
 <20100525184621.89487735.akpm@linux-foundation.org>
 <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com>
 <4BFD1F93.7080000@aixigo.de>
 <4C57BF1E.9080804@aixigo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C57BF1E.9080804@aixigo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 09:02:54AM +0200, Harald Dunkel wrote:
> Hi Kay,
> 
> Sorry for the delay.
> 
> It crashes when the "processor" acpi module is loaded.

Sounds like an ACPI bug.  The ACPI developers use the
bugzilla.kernel.org site to track things like this.  Try filing a bug
there and they can take care of it.

thanks,

greg k-h
