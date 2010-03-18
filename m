Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0CRXT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:19:58 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26164 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0CRXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:19:56 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous reboots [now 2.6.34-rc1]
Date: Thu, 18 Mar 2010 16:19:54 -0700
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <201003181658.38462.bjorn.helgaas@hp.com> <alpine.DEB.2.00.1003181858590.27400@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003181858590.27400@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003181719.55238.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 March 2010 05:00:02 pm Justin Piszcz wrote:
> On Thu, 18 Mar 2010, Bjorn Helgaas wrote:
> 
> > On Saturday 13 March 2010 02:01:32 am Justin Piszcz wrote:
> >> It stayed up for approximately 8-9 hours, then it crashed again.
> >>
> >> It is either a DOA motherboard OR the memory mapping is causing problems..
> >
> > Did you ever make any more progress on this?  I don't have any ideas;
> > just wondering whether you learned anything.

> I swapped the motherboard with the ASUS and all problems have disappeared. 
> Someone else e-mailed me with a similar issue (freeze/hang/etc) with a 
> similar motherboard (but UDP3 instead of 5 I believe) and they could not 
> find a solution either, they were trying to install Fedora.

Huh.  You started with a Gigabyte board, IIRC, and replaced it with
an ASUS, so we can't tell if you just had a defective Gigabyte board,
or if there's something we need to fix in Linux.

The other poster with a similar board and similar symptoms sounds
interesting, though.  You don't have a pointer to a bugzilla or
email discussion, do you?

Bjorn
