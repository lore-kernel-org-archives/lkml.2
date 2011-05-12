Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1ELHrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:47:25 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36887 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1ELHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:47:24 -0400
Date: Thu, 12 May 2011 09:47:20 +0200 (CEST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/5] Basic ARM devicetree support
In-Reply-To: <20110511211438.GM5315@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1105120940490.28229@xanadu.home>
References: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com> <20110511211438.GM5315@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, Russell King - ARM Linux wrote:

> On Wed, May 11, 2011 at 10:44:49PM +0200, Grant Likely wrote:
> > Right now it merges cleanly with linux-next and the resulting tree
> > builds and boots at least on qemu.  Unless you really object, I'm
> > going to ask Stephen to add the following branch to the /end/ of the
> > list of trees for linux-next so it can easily be dropped it if it
> > causes any problems.
> 
> As far as the set of five patches looks fine to me, I don't have any
> objections against them.  So I think we can merge them for .40.
> 
> What I've always worried about is the platform stuff, and that's
> something I'm going to continue worrying about because I don't think
> we have sufficient review capacity to ensure that we don't end up
> with lots of stupidities.

DT is certainly not a silver bullet.  Good judgement will be needed as 
to what is put in DT and how it is represented.  I don't think that it 
would make things worse than they are now though.

I also do have some concerns about some aspects of DT which I've 
expressed several times in the past.  However I don't think holding back 
those patches any longer is a solution though.

So consider this as a ACK from my part to merge those patches now.  This 
will get the ball rolling.


Nicolas
