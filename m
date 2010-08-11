Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0HKD3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:29:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60084 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab0HKD3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BrBd5HoTMJ2mbkbR8n53ZvWKDP3IuC9v7podxvpH5uUfXP5AM6BMZ+poztpEUehAsu
         6Whv8bRqAMk1PQ/JLwXussW+lED8RlKCJufXFy9puecyE04yUrmOcf0poKCqYxW33z1H
         WHaEm0n1G0tCRfnzd32XI7ru+HjQqJY1X44sc=
Date: Tue, 10 Aug 2010 20:29:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100811032929.GA10104@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
 <20100807152309.GF17833@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807152309.GF17833@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 05:23:09PM +0200, Daniel Mack wrote:
> Hi Dmitry,
> 
> sorry for the late reply on this, I guess I haven't been much help
> around here lately.
> 
> On Wed, Jul 21, 2010 at 01:30:48AM -0700, Dmitry Torokhov wrote:
> > The approach is pretty solid, with the exception that I do not think
> > we'd save much if we allocate every axis data separately (as I mentioned
> > in one of my earlier mails).
> 
> Agreed. We at least save the memory for all input devices that don't
> have absolute axis at all.
> 
> > Coudl you please take a look at the following patches and let me know if
> > you see something wrong.
> 
> I checked the patches and tried them locally on my desktop, and I can't
> see any breakage, but we might need more coverage for testing.
> 
> Will you push them to the .36 merge window or is it too late for this?
> 

Yep, it in mainline now. Thank you for working on this.

- 
Dmitry
