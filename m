Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0GCCA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:00:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0GCCAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:00:10 -0400
Date: Fri, 2 Jul 2010 18:57:13 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 054/149] powerpc/pseries: Only call start-cpu when a
 CPU is stopped
Message-ID: <20100703015713.GC16229@suse.de>
References: <20100701173211.356448329@clark.site>
 <24044.1278029021@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24044.1278029021@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 10:03:41AM +1000, Michael Neuling wrote:
> This is not going to work without:
> f8b67691828321f5c85bb853283aa101ae673130
> 
> It'll get a build failure.

That is because that patch does not apply to the .32 series.  If it is
needed, can you please send me a backported version to apply?

thanks,

greg k-h
