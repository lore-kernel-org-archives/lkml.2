Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0GERGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:06:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:45738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab0GERGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:06:36 -0400
Date: Mon, 5 Jul 2010 10:05:24 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [05/23] powerpc/pseries: Only call start-cpu when a CPU is
 stopped
Message-ID: <20100705170524.GC23581@suse.de>
References: <20100701172856.882121276@clark.site>
 <23995.1278028968@neuling.org>
 <20100703015627.GB16229@suse.de>
 <32150.1278143700@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32150.1278143700@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 05:55:00PM +1000, Michael Neuling wrote:
> In message <20100703015627.GB16229@suse.de> you wrote:
> > On Fri, Jul 02, 2010 at 10:02:48AM +1000, Michael Neuling wrote:
> > > This is not going to work without:
> > > f8b67691828321f5c85bb853283aa101ae673130
> > > 
> > > It'll get a build failure.
> > 
> > But that patch does not apply on the .27 series, care to provide a
> > backported version of it?
> 
> Sure... Compile and boot tested only.

Applied, thanks.

greg k-h
