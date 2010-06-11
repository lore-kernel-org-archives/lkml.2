Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab0FKMWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:22:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58806 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab0FKMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:22:39 -0400
Subject: Re: [PATCH] sa1111: Prevent deadlock in resume path
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marek Vasut <marek.vasut@gmail.com>, julia@diku.dk,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100610135609.GC4514@ucw.cz>
References: <1274901104-22133-1-git-send-email-marek.vasut@gmail.com>
	 <20100526191425.GD6232@n2100.arm.linux.org.uk>
	 <201005262115.57282.marek.vasut@gmail.com>
	 <20100526201824.GA16418@n2100.arm.linux.org.uk>
	 <20100610135609.GC4514@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 11 Jun 2010 13:22:16 +0100
Message-ID: <1276258936.16663.39.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2010 12:22:17.0123 (UTC) FILETIME=[BB216730:01CB0960]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 14:56 +0100, Pavel Machek wrote:
> On Wed 2010-05-26 21:18:24, Russell King - ARM Linux wrote:
> > On Wed, May 26, 2010 at 09:15:57PM +0200, Marek Vasut wrote:
> > > You want me to fight your patch tracking system or will you just merge it into
> > > your tree ?
> >
> > What do you mean "fight" ?  Just send a standard git formatted patch
> > to the email address with an additional KernelVersion: tag.  It's
> > not at all hard.
> 
> You are linux kernel maintainer. Start acting as one. It is not at all
> hard.
> 
> Alternatively, just remove KernelVersion: checking in  your
> scripts.

BTW (and I'm not complaining about Russell's patch system here), how can
we get the linux-arm-kernel list subscribed to patchwork.kernel.org?
That would be useful for grabbing RFC/CFT patches.

-- 
Catalin

