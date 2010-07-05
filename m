Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0GERGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:06:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0GERGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:06:30 -0400
Date: Mon, 5 Jul 2010 10:03:47 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 054/149] powerpc/pseries: Only call start-cpu when a
 CPU is stopped
Message-ID: <20100705170347.GA23581@suse.de>
References: <20100701173211.356448329@clark.site>
 <24044.1278029021@neuling.org>
 <20100703015713.GC16229@suse.de>
 <32137.1278143685@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32137.1278143685@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 05:54:45PM +1000, Michael Neuling wrote:
> > > This is not going to work without:
> > > f8b67691828321f5c85bb853283aa101ae673130
> > > 
> > > It'll get a build failure.
> > 
> > That is because that patch does not apply to the .32 series.  If it is
> > needed, can you please send me a backported version to apply?
> 
> Sure... Compile and boot tested only.

Applied now, thanks,

greg k-h
